//
//  DCUtils
//

import Foundation

extension Float: AsBool, AsInt, AsDouble {}

extension Float: TransformableType {
    public static let transformableType = "float"
}

public protocol AsFloat: AsTransformable {}

extension AsFloat {
    public var asFloat: Float { return asObject() ?? 0 }
}
