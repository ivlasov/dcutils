//
//  DCUtils
//

import Foundation

public func << <T>(lhs: inout Array<T>, rhs: T?) { lhs += rhs }

public func << <T>(lhs: inout Array<T>, rhs: Array<T>?) { lhs += rhs }

public func += <T>(lhs: inout Array<T>, rhs: T?)  { if let rhs = rhs { lhs.append(rhs) } }

public func += <T>(lhs: inout Array<T>, rhs: Array<T>?)  { if let rhs = rhs { for item in rhs { lhs << item } } }

public func -= <T>(lhs: inout Array<T>, rhs: T)  {
    if let rhs = (rhs as? NSObject) {
        var index: Int?
        var remove = true
        repeat {
            remove = false
            for (idx,item) in lhs.enumerated() {
                if let item = item as? NSObject {
                    if item == rhs {
                        remove = true
                        index = idx
                    }
                }
            }
            if remove {
                if let index = index {
                    lhs.remove(at: index)
                }
                index = nil
            }
        } while remove
    }
}

public func + <T>(lhs: Array<T>?, rhs: Array<T>?) -> Array<T>  {
    var list = Array<T>()
    if let lhs = lhs {
        for item in lhs {
            list << item
        }
    }
    if let rhs = rhs {
        for item in rhs {
            list << item
        }
    }
    return list
}

extension Array {
    public func transformed<T>(range: NSRange? = nil, _ transformation: (_ idx: Int, _ item: Element) -> T?) -> Array<T>? {
        var list = [T]()
        let range = range ?? NSMakeRange(0, count)
        for i in range.location ..< range.location + range.length {
            if let value = transformation(i, self[i]) { list << value }
        }
        return list
    }
}

extension Array {
    public func transformed<T>(range: NSRange? = nil, _ transformation: (_ idx: Int, _ item: Element) -> T?) -> Array<T> {
        return transformed(transformation) ?? []
    }
}

public extension Array where Element: CustomStringConvertible {
    public func joinedBy(separator: String) -> String {
        var string = ""
        for (idx,item) in enumerated() {
            string += item.description
            if idx != count - 1 {
                string += separator
            }
        }
        return string.count > 0 ? string : ""
    }
}

extension Array {
    public func array(range: NSRange) -> Array<Element> {
        return transformed(range: range) { (_,element) in return element } ?? []
    }
}

extension Array {
    public static func enumerate<T>(count: Int, _ handler: (_ idx: Int) -> T?) -> Array<T> {
        var list = [T]()
        for i in 0 ..< count {
            if let value = handler(i) { list << value }
        }
        return list
    }
}

extension Sequence where Element: Equatable {
    public var uniqueElements: [Element] {
        return self.reduce(into: []) { uniqueElements, element in
            if !uniqueElements.contains(element) { uniqueElements.append(element) }
        }
    }
}

public extension Collection where Index : Comparable, Index : Comparable {
    subscript (safe index: Index) -> Iterator.Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}

extension Dictionary {
    public var allKeys: [Key] {
        var keys = [Key]()
        for (key,_) in self { keys << key }
        return keys
    }
}

extension Dictionary {
    public func transform<K,V>(_ transformation: (_ key: Key, _ value: Value) -> [K:V]?) -> Dictionary<K,V>? {
        var dictionary = [K:V]()
        for (key,value) in self {
            dictionary << transformation(key, value)
        }
        return dictionary.count > 0 ? dictionary : nil
    }
}

extension Dictionary {
    public func transform<K,V>(_ transformation: (_ key: Key, _ value: Value) -> [K:V]?) -> Dictionary<K,V> {
        return transform(transformation) ?? [:]
    }
}

public func + <K,V>(lhs: Dictionary<K,V>?, rhs: Dictionary<K,V>?) -> Dictionary<K,V> {
    var info = Dictionary<K,V>()
    if let lhs = lhs {
        for (key,value) in lhs { info[key] = value }
    }
    if let rhs = rhs {
        for (key,value) in rhs { info[key] = value }
    }
    return info
}

public func << <K,V>(lhs: inout Dictionary<K,V>, rhs: Dictionary<K,V>?) {
    if let rhs = rhs {
        for (key,value) in rhs { lhs[key] = value }
    }
}
