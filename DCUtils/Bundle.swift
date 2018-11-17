//
//  DCFoundation-iOS
//

import Foundation

extension Bundle {
    public struct InfoDictionaryKey: Hashable {
        let rawValue: String
        public init(_ rawValue: String) { self.rawValue = rawValue }
        public static func ==(lhs: InfoDictionaryKey, rhs: InfoDictionaryKey) -> Bool { return lhs.rawValue == rhs.rawValue}
    }
}

extension Bundle {
    public var infoDictionaryKeys: [InfoDictionaryKey:Any] {
        var result = [InfoDictionaryKey:Any]()
        for (key,value) in (infoDictionary ?? [:]) {
            result[InfoDictionaryKey(key)] = value
        }
        return result
    }
}

extension Bundle.InfoDictionaryKey {
    public static let region            = Bundle.InfoDictionaryKey(kCFBundleDevelopmentRegionKey as String)
    public static let executable        = Bundle.InfoDictionaryKey(kCFBundleExecutableKey as String)
    public static let identifier        = Bundle.InfoDictionaryKey(kCFBundleIdentifierKey as String)
    public static let name              = Bundle.InfoDictionaryKey(kCFBundleNameKey as String)
    public static let localizations     = Bundle.InfoDictionaryKey(kCFBundleLocalizationsKey as String)
    public static let version           = Bundle.InfoDictionaryKey(kCFBundleVersionKey as String)
    public static let infoVersion       = Bundle.InfoDictionaryKey(kCFBundleInfoDictionaryVersionKey as String)
    public static let shortVersion      = Bundle.InfoDictionaryKey(kCFBundleVersionKey as String)
}
