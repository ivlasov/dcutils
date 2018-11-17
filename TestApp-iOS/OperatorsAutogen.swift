//
//  TestApp-iOS
//

import Foundation
import DCUtils

func generateNumbersAutogen() {
    let autogen = Autogen(
        operators: [
            Autogen.Operator(name: "==", isReversed: true),
            Autogen.Operator(name: "!=", isReversed: true),
            Autogen.Operator(name: "+"),
            Autogen.Operator(name: "-"),
            Autogen.Operator(name: "*"),
            Autogen.Operator(name: "/"),
            Autogen.Operator(name: "+="),
            Autogen.Operator(name: "-="),
            Autogen.Operator(name: "*="),
            Autogen.Operator(name: "/="),
        ], types: [
            "Bool",
            "Int",
            "Float",
            "Double"
        ]
    )
    
    autogen.log()
}



class Autogen {
    
    struct Operator {
        let name        : String
        let isReversed  : Bool
        init(name: String, isReversed: Bool = false) {
            self.name = name
            self.isReversed = isReversed
        }
    }
    
    let operators: [Operator]
    let types: [String]
    let code: String
    
    init(operators: [Operator], types: [String], code: String = "") {
        self.operators = operators
        self.types = types
        self.code = code
    }
    
    func log() {
        for first in 0 ..< types.count {
            print("-".fitIn(count: 40, symbol: "-") + "\n")
            print("\(types[first])".fitIn(count: 40) + "\n")
            for `operator` in operators {
                for second in 0 ..< types.count {
                    guard first != second else { continue }
                    log(operator: `operator`, pair: Pair(first, second))
                }
            }
            print("-".fitIn(count: 40, symbol: "-") + "\n\n")
        }
    }
    
    private func log(`operator`: Operator, pair: Pair<Int,Int>) {
        let left: String
        let right: String
        let condition: String
        let returnType = pair.first < pair.second ? types[pair.first] : types[pair.second]
        let type1: String
        let type2: String
        if `operator`.isReversed {
            type1 = types[pair.first]
            type2 = types[pair.second]
            left = "lhs"
            right = "rhs"
            condition = ""
        } else {
            if pair.first < pair.second {
                type1 = types[pair.first] + "?"
                left = "lhs?"
                type2 = types[pair.second]
                right = "rhs"
                condition = "\(left) \(`operator`.name) \(right)?.as\(type1)"
            } else {
                type1 = types[pair.first]
                left = "lhs"
                type2 = types[pair.second] + "?"
                right = "rhs?"
                condition = "\(left)?.as\(type2) \(`operator`.name) \(right)"
            }
        }
        print("public func \(`operator`.name) (\(left): \(type1)?, \(right): \(type2)?) -> \(returnType) { return \(condition) }")
    }
    
}

public func == (lhs: Bool?, rhs: Int?) -> Bool { return lhs == rhs?.asBool }
public func == (lhs: Int?, rhs: Bool?) -> Bool { return lhs?.asBool == rhs }

//public func == (lhs: Bool?, rhs: Int?) -> Bool {
//    return lhs == rhs?.asBool
//}
//
//public func == (lhs: Int?, rhs: Bool?) -> Bool {
//    return lhs?.asBool == rhs
//}
//
//public func + (lhs: Int?, rhs: Int) -> Int {
//    return lhs + rhs
//}
//public func + (lhs: Bool?, rhs: Int?) -> Int {
//    return lhs?.asInt + rhs
//}
//
//public func + (lhs: Int?, rhs: Bool?) -> Bool {
//    return lhs == rhs?.asInt
//}
