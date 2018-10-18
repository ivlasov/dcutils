//
//  DCUtils
//

import Foundation

extension Data {
    
    public func toString(encoding: String.Encoding = .utf8) -> String? {
        return String(data: self, encoding: encoding)
    }
    
    public var pushToken: String? {
        return (self as NSData).description.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "<", with: "")
            .replacingOccurrences(of: ">", with: "")
    }
    
}
