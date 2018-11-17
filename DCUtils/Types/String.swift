//
//  DCUtils
//

import Foundation

// MARK: Random

extension String {
    public static func random(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
}

// MARK: Fit

extension String {
    public func fitIn(count: Int, symbol: String = " ") -> String {
        guard self.count < count else { return String(self) }
        let count = count - self.count
        let left: Int = count/2
        let right = left*2 < count ? left + 1 : left
        var string = ""
        for _ in 0 ..< left {
            string += symbol
        }
        string += self
        for _ in 0 ..< right {
            string += symbol
        }
        return string
    }
}

// MARK: Substring

extension String {
    
    public subscript(i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    public subscript(bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    public subscript(bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    public func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }
    
    public func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

}

// MARK: Removing

extension String {
    public func removing(string: String) -> String {
        return replacingOccurrences(of: string, with: "")
    }
}

// MARK: Data

extension String {
    public func data(encoding: String.Encoding = .utf8) -> Data? {
        return data(using: encoding)
    }
}

// MARK: as String

extension String: AsBool, AsInt, AsFloat, AsDouble {}
extension Bool: AsString {}
extension Int: AsString {}
extension Float: AsString {}
extension Double: AsString {}

extension String: TransformableType {
    public static let transformableType = "string"
}

public protocol AsString: AsTransformable {}

extension AsString {
    public var asString: String! { return asObject() }
}
