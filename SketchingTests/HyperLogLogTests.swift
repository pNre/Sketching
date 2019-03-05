//
//  HyperLogLogTests.swift
//  SketchingTests
//
//  Created by Pierluigi D'Andrea on 02/03/2019.
//

import XCTest
@testable import Sketching

class HyperLogLogTests: XCTestCase {

    func testCorrectEmptyCardinality() {
        let hyperLogLog = HyperLogLog<FNV1AHashing>()
        XCTAssertEqual(hyperLogLog.cardinality(), 0)
    }

    func testInsertsValues() {
        var hyperLogLog = HyperLogLog<FNV1AHashing>()
        hyperLogLog.insert("a".utf8)
        hyperLogLog.insert("b".utf8)
        hyperLogLog.insert("c".utf8)
        hyperLogLog.insert("a".utf8)
        hyperLogLog.insert("b".utf8)
        XCTAssertEqual(hyperLogLog.cardinality(), 3, accuracy: 0.1)
    }

    func testUnion() {
        var hyperLogLog = HyperLogLog<FNV1AHashing>()
        hyperLogLog.insert("a".utf8)
        hyperLogLog.insert("b".utf8)
        hyperLogLog.insert("c".utf8)

        var otherHyperLogLog = HyperLogLog<FNV1AHashing>()
        otherHyperLogLog.insert("a".utf8)
        otherHyperLogLog.insert("d".utf8)

        var union = hyperLogLog.union(otherHyperLogLog)
        union.insert("a".utf8)
        union.insert("d".utf8)

        XCTAssertEqual(union.cardinality(), 4, accuracy: 0.1)
    }

}
