//
//  DCUtils
//

import Foundation

extension Bool: AsInt, AsFloat, AsDouble {}

extension Bool: TransformableType {
    public static let transformableType = "bool"
}

public protocol AsBool: AsTransformable {}

extension AsBool {
    public var asBool: Bool { return asObject() ?? false }
}
