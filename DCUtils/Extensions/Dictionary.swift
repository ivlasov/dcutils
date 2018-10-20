//
//  DCUtils
//

import Foundation

extension Encodable {
    public func jsonData() -> Data? {
        do {
            let coder = JSONEncoder()
            return try coder.encode(self)
        } catch {
            LogsWeak() << Utils.Log.Event(category: Utils.Log.Category.json, error: error)
            return nil
        }
    }
}

extension Dictionary where Key == String {
    public func jsonData() -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        } catch {
            LogsWeak() << Utils.Log.Event(category: Utils.Log.Category.json, error: error)
            return nil
        }
    }
}

extension Dictionary {
    
    public var allKeys: [Key] {
        var keys = [Key]()
        for (key,_) in self {
            keys << key
        }
        return keys
    }
    
}

public func + <K,V>(lhs: Dictionary<K,V>?, rhs: Dictionary<K,V>?) -> Dictionary<K,V> {
    var info = Dictionary<K,V>()
    if let lhs = lhs {
        for (key,value) in lhs {
            info[key] = value
        }
    }
    if let rhs = rhs {
        for (key,value) in rhs {
            info[key] = value
        }
    }
    return info
}

public func << <K,V>(lhs: inout Dictionary<K,V>, rhs: Dictionary<K,V>?) {
    if let rhs = rhs {
        for (key,value) in rhs {
            lhs[key] = value
        }
    }
}

