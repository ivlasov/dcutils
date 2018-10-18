//
//  DCUtils
//

import Foundation
import CommonCrypto

extension String {
    
    public func fitIn(length: Int, symbol: String = " ") -> String {
        guard self.length < length else { return String(self) }
        let count = length - self.length
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

extension String {
    
    public func date(format: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = format
        return df.date(from:self)
    }
    
}

extension String {
    
    public var localized: String {
        return LocalizedString(self)
    }
    
}

extension String {
    
    public subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    public func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    public func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
}

extension String {

    public var length: Int { return count }
    
    public func appending(pathComponent: String) -> String {
        return (self as NSString).appendingPathComponent(pathComponent)
    }
    
    public func toDouble() -> Double {
        return (self as NSString).doubleValue
    }
    
    public func toInt() -> Int {
        return (self as NSString).integerValue
    }
    
    public func toHex() -> String {
        return toInt().toHex()
    }
    
}

extension String {
    
    public var isValidEmail: Bool { return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isValidToRegex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}") }
    
    public var isValidPhoneNumber: Bool {
        let regex = "([\\+(]?(\\d){2,}[)]?[- \\.]?(\\d){2,}[- \\.]?(\\d){2,}[- \\.]?(\\d){2,}[- \\.]?(\\d){2,})|([\\+(]?(\\d){2,}[)]?[- \\.]?(\\d){2,}[- \\.]?(\\d){2,}[- \\.]?(\\d){2,})|([\\+(]?(\\d){2,}[)]?[- \\.]?(\\d){2,}[- \\.]?(\\d){2,})"
        return isValidToRegex(regex)
    }
    
    public func isValidToRegex(_ regex: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
    
}

extension String {
    
    public func URLEncodedString() -> String {
        return addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
    public func URLDecodedString() -> String {
        return removingPercentEncoding ?? ""
    }
    
}

extension String {

    public var MD5: String {
        let messageData = data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))

        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }

        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }

}

extension String {
    
    public subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    public subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
}


extension String {
    
    public func toData(encoding: String.Encoding = .utf8) -> Data? {
        return data(using: encoding)
    }
    
}

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
