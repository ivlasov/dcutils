//
//  DCUtils
//

import Foundation

extension Foundation.UserDefaults {
    public struct Key {
        let rawValue: String
        init(_ rawValue: String) { self.rawValue = rawValue }
    }
}

public func UserDefaults() -> Foundation.UserDefaults {
    return Foundation.UserDefaults.standard
}

public extension Foundation.UserDefaults {

    public subscript<T>(key: String) -> T? {
        get { return object(forKey: key) as? T }
        set {
            if let newValue = newValue {
                set(newValue, forKey: key)
            } else {
                removeObject(forKey: key)
            }
        }
    }
    
    public subscript<T>(key: Key) -> T? {
        get { return self[key.rawValue] }
        set { self[key.rawValue] = newValue }
    }
    
}
