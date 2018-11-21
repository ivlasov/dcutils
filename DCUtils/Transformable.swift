//
//  DCUtils
//

import Foundation

public protocol Transformable {
    associatedtype T
    associatedtype K
    func transform(value: T?) -> K?
    func transform(value: K?) -> T?
}

public protocol TransformableType {
    static var transformableType: String { get }
}

extension TransformableType {
    public static func asRegister<T:TransformableType>(type: T.Type, direct: @escaping (Self?) throws -> T?, reverse: @escaping (T?) throws -> Self?) rethrows {
        AsTransformableImplementaion.register(transformation: try AsTransform(reverse, direct))
    }
}

internal class AsTransform<Q:TransformableType,W:TransformableType>: Transformable {
    
    public typealias T = Q
    public typealias K = W
    public typealias DirectTransform = (T?) throws -> K?
    public typealias ReverseTransform = (K?) throws -> T?
    
    public func transform(value: T?) -> K? {
        return value as? K
    }
    
    public func transform(value: K?) -> T? {
        return value as? T
    }
    
    private let direct: DirectTransform
    private let reverse: ReverseTransform
    
    init(_ direct: @escaping DirectTransform, _ reverse: @escaping ReverseTransform) rethrows {//} @escaping (T?) -> K?, reverse: @escaping (K?) -> T?) {
        self.direct = direct
        self.reverse = reverse
    }
    
}

public protocol AsTransformable: TransformableType {}

extension AsTransformable {
    public typealias Transformation = ((Any?) -> Any?)
    public func asObject<T:TransformableType>()-> T? { return AsTransformableImplementaion.convert(object: self) }
}

private enum AsTransformableImplementaion {
    
    typealias Transformation = ((Any?) -> Any?)
    
    struct Container {
        let types: Pair<String,String>
        let transformation: Transformation
    }
    
    static var containers = [Container]()
    
    static func preload() {
        String  .asRegister(type: Bool.self,    direct: { $0 == nil ? nil : ($0 as NSString?)?.boolValue    }, reverse: { $0 == nil ? nil : "\($0 ?? false)"    })
        String  .asRegister(type: Int.self,     direct: { $0 == nil ? nil : ($0 as NSString?)?.integerValue }, reverse: { $0 == nil ? nil : "\($0 ?? 0)"        })
        String  .asRegister(type: Float.self,   direct: { $0 == nil ? nil : ($0 as NSString?)?.floatValue   }, reverse: { $0 == nil ? nil : "\($0 ?? 0.0)"      })
        String  .asRegister(type: Double.self,  direct: { $0 == nil ? nil : ($0 as NSString?)?.doubleValue  }, reverse: { $0 == nil ? nil : "\($0 ?? 0.0)"      })
        Bool    .asRegister(type: Int.self,     direct: { ($0 ?? false) ? 0 : 1                             }, reverse: { ($0 ?? 0) > 0                         })
        Bool    .asRegister(type: Float.self,   direct: { ($0 ?? false) ? 0.0 : 1.0                         }, reverse: { ($0 ?? 0.0) > 0.0                     })
        Bool    .asRegister(type: Double.self,  direct: { ($0 ?? false) ? 0.0 : 1.0                         }, reverse: { ($0 ?? 0.0) > 0.0                     })
        Int     .asRegister(type: Float.self,   direct: { $0 == nil ? nil : Float($0 ?? 0)                  }, reverse: { $0 == nil ? nil : Int($0 ?? 0)        })
        Int     .asRegister(type: Double.self,  direct: { $0 == nil ? nil : Double($0 ?? 0)                 }, reverse: { $0 == nil ? nil : Int($0 ?? 0)        })
        Float   .asRegister(type: Double.self,  direct: { $0 == nil ? nil : Double($0 ?? 0)                 }, reverse: { $0 == nil ? nil : Float($0 ?? 0)      })
    }
    
    static func register<T:TransformableType,K:TransformableType>(transformation: AsTransform<T,K>) {
        let from: Transformation = { object in
            if let object = object as? T { return transformation.transform(value: object) }
            return nil
        }
        let to: Transformation = { object in
            if let object = object as? K { return transformation.transform(value: object) }
            return nil
        }
        AsTransformableImplementaion.containers << Container(types: Pair(T.transformableType, K.transformableType), transformation: from)
        AsTransformableImplementaion.containers << Container(types: Pair(K.transformableType, T.transformableType), transformation: to)
    }
    
    static func convert<T:TransformableType,K:TransformableType>(object: T?) -> K? {
        if AsTransformableImplementaion.containers.count == 0 { AsTransformableImplementaion.preload() }
        let pair = Pair(T.transformableType, K.transformableType)
        for container in AsTransformableImplementaion.containers {
            if container.types.first == pair.first && container.types.second == pair.second {
                return container.transformation(object) as? K
            }
        }
        return nil
    }
    
}
