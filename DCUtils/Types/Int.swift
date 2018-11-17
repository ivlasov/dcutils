//
//  DCUtils
//

import Foundation

extension Int: AsBool, AsFloat, AsDouble {}

extension Int: TransformableType {
    public static let transformableType = "int"
}

public protocol AsInt: AsTransformable {}

extension AsInt {
    public var asInt: Int { return asObject() ?? 0 }
}
