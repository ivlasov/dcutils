//
//  DCUtils
//

import Foundation

fileprivate let domain = "com.dclife.utils"

public enum Utils {
    enum Log {
        static let `default`    = "\(domain)|default"
        static let json         = "\(domain)|json"
        static let fileSystem   = "\(domain)|fileSystem"
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
