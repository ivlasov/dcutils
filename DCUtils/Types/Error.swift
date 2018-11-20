//
//  DCUtils
//

import Foundation

extension NSError {
    public static func localized(key: String?, code: Int? = nil, domain: String? = nil, userInfo:[String:Any]? = nil) -> Error? {
        guard let key = key else { return nil }
        let code = code ?? -1
        var domain: String! = domain
        if domain == nil {
            if let identifier = (Bundle.main.infoDictionary?[kCFBundleIdentifierKey as String] as? String) {
                domain = identifier + ".error"
            } else {
                domain = (Bundle.main.infoDictionaryKeys[.identifier] as? String) ?? "com.dclife.error"
            }
        }
        return NSError(domain: domain, code: code, userInfo: ([NSLocalizedDescriptionKey:key.localized]) + userInfo)
    }
}
