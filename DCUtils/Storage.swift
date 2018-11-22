//
//  DCUtils
//

import Foundation

public enum Storage {
    public enum Directory {}
}

public protocol StorageItem {
    var origin  : String { get }
    var url     : URL { get }
    var path    : String { get }
    var name    : String { get }
    var exists  : Bool { get }
    init?(path: String)
    init?(url: URL)
}

extension StorageItem {
    
    @discardableResult public func move(to path: String) -> Bool {
        return move(to: URL(fileURLWithPath: path))
    }
    
    @discardableResult public func move(to url: URL) -> Bool {
        do {
            try FileManager.default.moveItem(at: self.url, to: url)
            return true
        } catch {
            Logs.weak << Utils.Log.Event(category: Utils.Log.Category.storage, error: error)
            return false
        }
    }
    
    @discardableResult public func copy(to path: String) -> Bool {
        return copy(to: URL(fileURLWithPath: path))
    }
    
    @discardableResult public func copy(to url: URL) -> Bool {
        do {
            try FileManager.default.copyItem(at: url, to: url)
            return true
        } catch {
            Logs.weak << Utils.Log.Event(category: Utils.Log.Category.storage, error: error)
            return false
        }
    }
    
    @discardableResult public func delete() -> Bool {
        do {
            try FileManager.default.removeItem(at: url)
            return true
        } catch {
            Logs.weak << Utils.Log.Event(category: Utils.Log.Category.storage, error: error)
            return false
        }
    }
    
}

extension Storage {
    public class File: StorageItem {
        
        public let origin       : String
        public let url          : URL
        public let path         : String
        public let name         : String
        public let `extension`  : String
        
        public var exists: Bool {
            var isDir: ObjCBool = true
            return FileManager.default.fileExists(atPath: path, isDirectory: &isDir) && !isDir.boolValue
        }
        
        required public init?(path: String) {
            self.url = URL(fileURLWithPath: path)
            guard url.isFileURL else { return nil }
            self.origin = path
            self.extension = (origin as NSString).pathExtension
            self.name = (origin as NSString).lastPathComponent.replacingOccurrences(of: ".\(self.extension)", with: "")
            self.path = origin.replacingOccurrences(of: "\(self.name).\(self.extension)", with: "")
        }
        
        required public init?(url: URL) {
            guard url.isFileURL else { return nil }
            self.origin = ""
            self.url = url
            self.extension = ""
            self.name = ""
            self.path = ""
        }
        
        required public init?(known: Storage.Directory.Known, filename: String) {
            guard let url = known.url(file: filename), url.isFileURL else { return nil }
            self.origin = ""
            self.url = url
            self.extension = ""
            self.name = ""
            self.path = ""
        }
        
        @discardableResult public func create(contents: Data?, attributes: [FileAttributeKey:Any]? = nil, replace: Bool = false) -> Bool {
            if replace, exists { delete() }
            return FileManager.default.createFile(atPath: path, contents: contents, attributes: attributes)
        }
        
    }
}

extension Storage {
    public class Directory1 {
        
        public let origin       : String
        public let url          : URL
        public let path         : String
        public let name         : String
        public let `extension`  : String
        
        public var exists: Bool {
            var isDir: ObjCBool = false
            return FileManager.default.fileExists(atPath: path, isDirectory: &isDir) && !isDir.boolValue
        }
        
        public init?(path: String) {
            self.url = URL(fileURLWithPath: path)
            guard url.isFileURL else { return nil }
            self.origin = path
            self.extension = (origin as NSString).pathExtension
            self.name = (origin as NSString).lastPathComponent.replacingOccurrences(of: ".\(self.extension)", with: "")
            self.path = origin.replacingOccurrences(of: "\(self.name).\(self.extension)", with: "")
        }
        
        public init?(url: URL) {
            guard url.isFileURL else { return nil }
            self.origin = ""
            self.url = url
            self.extension = ""
            self.name = ""
            self.path = ""
        }
        
    }
}

extension Storage.Directory {
    public static func existsAt(path: String) -> Bool {
        var isDir: ObjCBool = false
        return FileManager.default.fileExists(atPath: path, isDirectory: &isDir) && isDir.boolValue
    }
}

extension Storage.Directory {
    @discardableResult public static func createAt(path: String) -> Bool {
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            Logs.weak << Utils.Log.Event(category: Utils.Log.Category.storage, error: error)
        }
        return false
    }
}

extension Storage.Directory {
    public static func contentsAt(path: String) -> [String]? {
        var contents: [String]?
        do {
            contents = try FileManager.default.contentsOfDirectory(atPath: path)
        } catch {
            Logs.weak << Utils.Log.Event(category: Utils.Log.Category.storage, error: error)
        }
        return contents
    }
}

extension Storage.Directory {
    
    public enum Known {
        case home
        case documents
        case cache
        case temp
    
        public func path(file: String = "") -> String? {
            let path: String
            switch self {
            case .home        : path = NSHomeDirectory()
            case .documents   : path = NSHomeDirectory().appending(path: "Documents")
            case .cache       : path = NSHomeDirectory().appending(path: "Library/Caches")
            case .temp        : path = NSHomeDirectory().appending(path: "tmp")
            }
            var exists: ObjCBool = false
            guard FileManager.default.fileExists(atPath: path, isDirectory: &exists), exists.boolValue else { return nil }
            return file.count > 0 ? path.appending(path: file) : path
        }
        
        public func url(file: String = "") -> URL? {
            if let value = path(file: file) { return URL(fileURLWithPath: value) }
            return nil
        }
        
    }
    
}

extension String {
    public func appending(path: String) -> String {
        return (self as NSString).appendingPathComponent(path)
    }
}

extension String {
    var file: Storage.File? { return Storage.File(path: self) }
}

extension URL {
    var file: Storage.File? { return Storage.File(url: self) }
}
