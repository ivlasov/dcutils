//
//  DCUtils
//

import Foundation

extension Locale {
    public static func emojiFlag(country code: String) -> String? {
        guard code.count == 2 else { return nil }
        let base = 127397
        var usv = String.UnicodeScalarView()
        for i in code.utf16 { usv.append(UnicodeScalar(base + Int(i))!) }
        return String(usv)
    }
}
