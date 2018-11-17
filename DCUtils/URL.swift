//
//  DCUtils
//

import Foundation

extension URL {
    public var queryParameters: [String:String]? {
        guard let list = query?.components(separatedBy: "&")  else { return nil }
        var params = [String:String]()
        for item in list {
            let comps = item.components(separatedBy: "=")
            guard
                comps.count == 2,
                let key = comps.first?.urlDecoded(),
                let value = comps.last?.urlDecoded()
            else { continue}
            params[key] = value
        }
        return params.count > 0 ? params : nil
    }
}

