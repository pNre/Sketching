//
//  BloomFilterTests.swift
//  SketchingTests
//
//  Created by Pierluigi D'Andrea on 06/03/2019.
//

import XCTest
@testable import Sketching

class BloomFilterTests: XCTestCase {

    func testHashCount() {
        let f = BloomFilter<FNV1AHashing>(bitWidth: 128, hashCount: 16)
        XCTAssertEqual(f.hashCount, 16)
    }

    func testEmptyCardinality() {
        let f = BloomFilter<FNV1AHashing>(bitWidth: 128, hashCount: 16)
        XCTAssertEqual(f.cardinality(), 0)
    }

    func testContains() {
        let base = Set((0..<64).map { _ in randomBytes(16) })
        let test = Set((0..<64).map { _ in randomBytes(16) }).union(base)

        var f = BloomFilter<FNV1AHashing>(expectedCardinality: base.count, probabilityOfFalsePositives: 0.001)
        base.forEach {
            f.insert($0)
        }

        for x in test where !f.contains(x) {
            XCTAssertFalse(base.contains(x))
        }
    }

}

extension BloomFilterTests {

    private func randomBytes(_ length: Int) -> [UInt8] {
        return (0..<length).map { _ in UInt8.random(in: 0..<UInt8.max) }
    }

}
