//
//  CountMinTests.swift
//  SketchingTests
//
//  Created by Pierluigi D'Andrea on 10/03/2019.
//

import XCTest
@testable import Sketching

class CountMinTests: XCTestCase {

    func testUpdate() {
        var c = CountMin<FNV1AHashing>(epsilon: 0.01, delta: 0.99)
        c.update("a".utf8, value: 100)
        c.update("b".utf8, value: 50)
        c.update("c".utf8, value: 1032950)
        c.update("b".utf8, value: 100)
        c.update("d".utf8, value: 10)

        XCTAssertEqual(c.estimateCount(for: "a".utf8), 100)
        XCTAssertEqual(c.estimateCount(for: "b".utf8), 150)
        XCTAssertEqual(c.estimateCount(for: "c".utf8), 1032950)
        XCTAssertEqual(c.estimateCount(for: "d".utf8), 10)
    }

    func testEstimate() {
        var c = CountMin<FNV1AHashing>(epsilon: 0.01, delta: 0.99)
        c.update("a".utf8, value: 100)
        c.update("b".utf8, value: 50)

        XCTAssertEqual(c.estimateCount(for: "a".utf8), 100)
        XCTAssertEqual(c.estimateCount(for: "b".utf8), 50)
        XCTAssertEqual(c.estimateCount(for: "c".utf8), 0)
    }

    func testUnion() {
        var a = CountMin<FNV1AHashing>(epsilon: 0.01, delta: 0.99)
        a.update("a".utf8, value: 100)
        a.update("b".utf8, value: 50)

        var b = CountMin<FNV1AHashing>(epsilon: 0.01, delta: 0.99)
        b.update("a".utf8, value: 10)
        b.update("b".utf8, value: 20)

        let c = a.union(b)
        XCTAssertEqual(c.estimateCount(for: "a".utf8), 110)
        XCTAssertEqual(c.estimateCount(for: "b".utf8), 70)
    }

}
