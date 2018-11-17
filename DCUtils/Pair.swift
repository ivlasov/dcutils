//
//  DCUtils
//

import Foundation

/**
 Pairing Protocol.
 
 Use this protocol for
 */

public protocol Pairing {
    associatedtype First
    associatedtype Second
    init(_ first: First, _ second: Second)
}

/**
 Brief description.
 Brief description continued.
 
 Details follow here.
 */

public struct Pair<First,Second>: Pairing {
    public var first   : First
    public var second  : Second
    public init(_ first: First, _ second: Second) {
        self.first = first
        self.second = second
    }
}
