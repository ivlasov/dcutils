//
//  Transform.swift
//  TestApp-iOS
//

import Foundation
import DCUtils

func testAsTransform() {
    log(type: String.self) { newLine in
        test(string: "")
        newLine()
        test(string: "aaa")
        newLine()
        test(string: "99")
        newLine()
        test(string: "true")
        newLine()
        test(string: "false")
    }

    log(type: Bool.self) { newLine in
        test(bool: true)
        newLine()
        test(bool: false)
    }

    log(type: Int.self) { (newLine) in
        test(int: -55)
        newLine()
        test(int: 0)
        newLine()
        test(int: 999)
        newLine()
    }

    log(type: Float.self) { (newLine) in
        test(float: -55.0)
        newLine()
        test(float: 0.0)
        newLine()
        test(float: 999.0)
        newLine()
    }

    log(type: Double.self) { (newLine) in
        test(float: -55.0)
        newLine()
        test(float: 0.0)
        newLine()
        test(float: 999.0)
        newLine()
    }
}

private func log<T:TransformableType>(type: T.Type, _ block: (( (() -> Void) ) -> Void)) {
    let newLine: (() -> Void) = {
        print("".fitIn(count: 20, symbol: "-"))
    }
    print("".fitIn(count: 20, symbol: "-"))
    print("|" + type.transformableType.fitIn(count: 18, symbol: "-") + "|")
    print("".fitIn(count: 20, symbol: "-"))
    block(newLine)
    print("".fitIn(count: 20, symbol: "-"))
    print("\n")
}

private func logTest<T:TransformableType,R>(type: T.Type, result: R) {
    print("\(type.transformableType.fitIn(count: 10, symbol: " ")): \(String(describing: result))")
}

private func logTestTitle<T:TransformableType>(value: T) {
    print("|" + String(describing: value).fitIn(count: 18, symbol: " ") + "|")
    print("".fitIn(count: 20, symbol: "-"))
}

private func test(string: String) {
    logTestTitle(value: string)
    logTest(type: Bool.self,    result: string.asBool)
    logTest(type: Int.self,     result: string.asInt)
    logTest(type: Float.self,   result: string.asFloat)
    logTest(type: Double.self,  result: string.asDouble)
}

private func test(bool: Bool) {
    logTestTitle(value: bool)
    print("".fitIn(count: 20, symbol: "-"))
    logTest(type: String.self,  result: bool.asString)
    logTest(type: Int.self,     result: bool.asInt)
    logTest(type: Float.self,   result: bool.asFloat)
    logTest(type: Double.self,  result: bool.asDouble)
}

private func test(int: Int) {
    logTestTitle(value: int)
    print("".fitIn(count: 20, symbol: "-"))
    logTest(type: String.self,  result: int.asString)
    logTest(type: Bool.self,    result: int.asBool)
    logTest(type: Float.self,   result: int.asFloat)
    logTest(type: Double.self,  result: int.asDouble)
}

private func test(float: Float) {
    logTestTitle(value: float)
    print("".fitIn(count: 20, symbol: "-"))
    logTest(type: String.self,  result: float.asString)
    logTest(type: Int.self,     result: float.asInt)
    logTest(type: Bool.self,    result: float.asBool)
    logTest(type: Double.self,  result: float.asDouble)
}

private func test(double: Double) {
    logTestTitle(value: double)
    print("".fitIn(count: 20, symbol: "-"))
    logTest(type: String.self,  result: double.asString)
    logTest(type: Int.self,     result: double.asInt)
    logTest(type: Bool.self,    result: double.asBool)
    logTest(type: Float.self,   result: double.asFloat)
}
