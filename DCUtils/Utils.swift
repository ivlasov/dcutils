//
//  DCUtils
//

import Foundation

public enum Utils {
    public enum Log {
        static let domain = "com.dclife.utils"
        enum Category {
            static let `default`    = "\(Utils.Log.domain)|default"
            static let json         = "\(Utils.Log.domain)|json"
            static let storage      = "\(Utils.Log.domain)|storage"
        }
    }
}

public extension Array {
    func debugPrint() {
        print(self)
    }
}

extension Dictionary {
    func debugPrint() {
        print(self)
    }
}

