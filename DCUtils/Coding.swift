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
            Logs.weak << Utils.Log.Event(category: Utils.Log.Category.json, error: error)
            return nil
        }
    }
}

extension Dictionary where Key: CustomStringConvertible {
    public func jsonData() -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        } catch {
            Logs.weak << Utils.Log.Event(category: Utils.Log.Category.json, error: error)
            return nil
        }
    }
}

extension String {
    
    public func urlEncoded() -> String {
        return addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
    public func urlDecoded() -> String {
        return removingPercentEncoding ?? ""
    }
    
}
