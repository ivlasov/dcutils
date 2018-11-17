//
//  DCUtils-iOS
//

import Foundation

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
