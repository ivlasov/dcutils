//
//  DCUtils
//

import Foundation

extension String {
    public var localized: String { return Localization.current[self] }
}


public class Localization {
    
    public static let didChange = Notification.Name("Localization.didChange")
    
    static var available = [Localization]()
    static var localization: Localization?
    
    static let currentKey = "Localization.currentKey"
    
    public static var useDebug = false
    public static var useEmptyKeys = true
    public static var showDefaultLanguageOnEmpty = true
    
    // MARK: - Static
    
    public static func localizations() -> [Localization] {
        preload()
        return available
    }
    
    public static func localization(identifier: String) -> Localization? {
        for item in available {
            if item.identifier == identifier { return item }
        }
        if let localization = Localization(identifier: identifier) {
            available << localization
            return localization
        }
        return nil
    }
    
    public static var `default` = Localization.localization(identifier: "en_US")!
    
    public static func set(current: Localization, notify: Bool = true) {
        let notify = notify ? (localization != nil) : notify
        guard localization != current else { return }
        localization = current
        UserDefaults().setValue(current.identifier, forKey: currentKey)
        UserDefaults().synchronize()
        if notify { Notification.post(name: Localization.didChange, object: nil, userInfo: nil) }
    }
    
    public static var current: Localization {
        set { set(current: newValue) }
        get {
            preload()
            if localization == nil {
                if let identifier = (Foundation.UserDefaults.standard.value(forKey: currentKey) as? String) {
                    localization = localization(identifier: identifier)
                } else if available.count == 1 {
                    localization = available.first!
                } else {
                    localization = .default
                }
            }
            
            return localization!
        }
    }
    
    static var isPreloaded = false
    
    static func preload() {
        if isPreloaded { return }
        isPreloaded = true
        guard available.count == 0 else { return }
        for identifier in Locale.availableIdentifiers {
            let pathFormat = "%@/%@.lproj"
            let name = identifier.replacingOccurrences(of: "_", with: "-")
            if let bundle = Bundle(path: String(format: pathFormat, arguments: [Bundle.main.bundlePath, name])), let localization = Localization(identifier: identifier) {
                if let path = bundle.path(forResource: "Localizable", ofType: "strings") {
                    localization.add(path: path)
                }
                available << localization
            }
        }
        if available.count == 0, let localization = Localization(identifier: "en") {
            if let path = Bundle.main.path(forResource: "Localizable", ofType: "strings") {
                localization.add(path: path)
            } else if useDebug {
                let comps = NSHomeDirectory().components(separatedBy: "/")
                if comps.count > 2 {
                    let home = "/" + comps[1] + "/" + comps[2]
                    let path = home.appending(path: "Library/Application Support/Xcode/XIBLocalizations.strings")
                    if Storage.File(path: path)?.exists == true {
                        localization.add(path: path)
                    }
                }
            }
            available << localization
        }
    }
    
    // MARK: - Properties
    
    public let locale: Locale
    public let identifier: String
    public let name: String
    public let localizedName: String
    
//     {
//        if let name = (locale as NSLocale?)?.displayName(forKey: NSLocale.Key.identifier, value: identifier), name.length > 0 {
//            return name.substring(toIndex: 1).uppercased() + name.substring(toIndex: 1)
//        }
//        return ""
//    }
    
//    public var localizedName: String {
//        if let name = (Localization.localization?.locale as NSLocale?)?.displayName(forKey: NSLocale.Key.identifier, value: identifier) { return name }
//        return ""
//    }
    
    public var allKeys: [String] { return strings.allKeys }
    
    var strings = [String:String]()

    // MARK: - Init
    
    init?(identifier: String) {
        self.locale = Locale(identifier: identifier)
        self.identifier = identifier
        if let name = (locale as NSLocale).displayName(forKey: .identifier, value: identifier) {
            self.name = name
        } else { return nil }
        if identifier == "en" {
            self.localizedName = self.name
        } else {
            if let localizedName = (Localization.current.locale as NSLocale).displayName(forKey: .identifier, value: identifier) {
                self.localizedName = localizedName
            } else {
                return nil
            }
        }
    }
    
    public subscript(key: String) -> String {
        if let value = strings[key] {
            if value.count == 0 {
                if Localization.useEmptyKeys { return value }
            } else { return value }
        }
        if Localization.showDefaultLanguageOnEmpty {
            if let value = Localization.default.strings[key] { return value }
        }
        return key
    }
    
    // MARK: - Methods
    
    public func add(path: String, replace: Bool = true) {
        if let strings = (NSDictionary(contentsOfFile: path) as? [String:String]) {
            add(strings: strings, replace: replace)
        }
    }
    
    public func add(strings: [String:String], replace: Bool = true) {
        for (key,value) in strings {
            let value = value.replacingOccurrences(of: "%s", with: "%@")
            if replace {
                self.strings[key] = value
            } else if strings[key] == nil {
                self.strings[key] = value
            }
        }
    }
    
    public static func == (left: Localization, right: Localization?) -> Bool {
        return left.identifier == right?.identifier
    }
    
    public static func != (left: Localization, right: Localization?) -> Bool {
        return left.identifier != right?.identifier
    }
    
}

public func == (left: Localization?, right: Localization?) -> Bool {
    return left?.identifier == right?.identifier
}

public func != (left: Localization?, right: Localization?) -> Bool {
    return left?.identifier != right?.identifier
}
