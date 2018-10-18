//
//  DCUtils
//

import Foundation

extension URL {
    
    public var queryParameters: [String:String]? {
        if let list = query?.components(separatedBy: "&") {
            var params = [String:String]()
            for item in list {
                let comps = item.components(separatedBy: "=")
                guard let key = comps.first?.URLDecodedString() else {
                    continue
                }
                guard let value = comps.last?.URLDecodedString() else {
                    continue
                }
                params[key] = value
            }
            return params.count > 0 ? params : nil
        }
        return nil
    }
    
}
