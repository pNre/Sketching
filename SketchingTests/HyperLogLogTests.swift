//
//  HyperLogLogTests.swift
//  SketchingTests
//
//  Created by Pierluigi D'Andrea on 02/03/2019.
//

import XCTest
@testable import Sketching

class HyperLogLogTests: XCTestCase {

    private var hyperLogLog: HyperLogLog<FNV1AHashing>!

    override func setUp() {
        hyperLogLog = HyperLogLog<FNV1AHashing>()
    }

    func testCorrectEmptyCardinality() {
        XCTAssertEqual(hyperLogLog.cardinality(), 0)
    }

    func testInsertsValues() {
        hyperLogLog.insert("a".utf8)
        hyperLogLog.insert("b".utf8)
        hyperLogLog.insert("c".utf8)
        hyperLogLog.insert("a".utf8)
        hyperLogLog.insert("b".utf8)
        XCTAssertEqual(hyperLogLog.cardinality(), 3, accuracy: 0.1)
    }

    func testUnion() {
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

private class FNV1AHashing: Hashing {
    static func hash<C: Collection>(_ val: C) -> UInt32 where C.Element == UInt8 {
        var hash: UInt32 = 2166136261
        for byte in val {
            hash ^= UInt32(byte)
            hash = hash &* 16777619
        }
        return hash
    }
}
