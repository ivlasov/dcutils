//
//  DCUtils
//

import Foundation

extension Double: AsBool, AsInt, AsFloat {}

extension Double: TransformableType {
    public static let transformableType = "double"
}

public protocol AsDouble: AsTransformable {}

extension AsDouble {
    public var asDouble: Double { return asObject() ?? 0 }
}
