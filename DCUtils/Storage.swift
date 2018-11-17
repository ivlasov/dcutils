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
        case home(path: String)
        case documents(path: String)
        case cache(path: String)
        case temp(path: String)
    }
    
    public static func path(known: Known) -> String {
        switch known {
        case .home(let path)        : return NSHomeDirectory().appending(path: path)
        case .documents(let path)   : return Storage.Directory.path(known: Storage.Directory.Known.home(path: "Documents")).appending(path)
        case .cache(let path)       : return Storage.Directory.path(known: Storage.Directory.Known.home(path: "Library/Caches")).appending(path)
        case .temp(let path)        : return Storage.Directory.path(known: Storage.Directory.Known.home(path: "tmp")).appending(path)
        }
    }
    
    public static func url(known: Known) -> URL? {
        return URL(fileURLWithPath: path(known: known))
    }
    
}

extension String {
    public func appending(path: String) -> String {
        return (self as NSString).appendingPathComponent(path)
    }
}
