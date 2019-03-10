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
        let base = randomSetOfBytes(count: 64)
        let test = randomSetOfBytes(count: 64).union(base)

        var f = BloomFilter<FNV1AHashing>(expectedCardinality: base.count, probabilityOfFalsePositives: 0.001)
        base.forEach {
            f.insert($0)
        }

        for x in test where !f.contains(x) {
            XCTAssertFalse(base.contains(x))
        }
    }

    func testUnion() {
        let base1 = randomSetOfBytes(count: 64)
        let base2 = randomSetOfBytes(count: 64)
        let base = base1.union(base2)
        let test = randomSetOfBytes(count: 64).union(base)

        var f1 = BloomFilter<FNV1AHashing>(expectedCardinality: base1.count, probabilityOfFalsePositives: 0.001)
        base1.forEach {
            f1.insert($0)
        }

        var f2 = BloomFilter<FNV1AHashing>(expectedCardinality: base2.count, probabilityOfFalsePositives: 0.001)
        base2.forEach {
            f2.insert($0)
        }

        f1.formUnion(f2)

        for x in test where !f1.contains(x) {
            XCTAssertFalse(base.contains(x))
        }
    }

    func testIntersection() {
        let u = randomSetOfBytes(count: 64)
        let s1 = randomSetOfBytes(count: 64).union(u)
        let s2 = randomSetOfBytes(count: 64).union(u)
        let i = s1.intersection(s2)

        var f1 = BloomFilter<FNV1AHashing>(expectedCardinality: s1.count, probabilityOfFalsePositives: 0.001)
        s1.forEach {
            f1.insert($0)
        }

        var f2 = BloomFilter<FNV1AHashing>(expectedCardinality: s2.count, probabilityOfFalsePositives: 0.001)
        s2.forEach {
            f2.insert($0)
        }

        f1.formIntersection(f2)

        for x in i where !f1.contains(x) {
            XCTAssertFalse(i.contains(x))
        }
    }

    func testProbabilityOfFalsePositives() {
        let hashCount = { (w: Double, items: Int) -> Int in Int((w / Double(items) * log(2)).rounded(.up)) }
        let f1 = BloomFilter<FNV1AHashing>(bitWidth: 256, hashCount: hashCount(256, 10))
        XCTAssertLessThan(f1.probabilityOfFalsePositives(for: 10), 0.001)

        let f2 = BloomFilter<FNV1AHashing>(bitWidth: 4096, hashCount: hashCount(4096, 100))
        XCTAssertLessThan(f2.probabilityOfFalsePositives(for: 100), 0.001)
    }

}

extension BloomFilterTests {

    private func randomSetOfBytes(count: Int, byteCount: Int = 8) -> Set<[UInt8]> {
        return Set((0..<count).map { _ in randomBytes(count: byteCount) })
    }

    private func randomBytes(count: Int) -> [UInt8] {
        return (0..<count).map { _ in UInt8.random(in: 0..<UInt8.max) }
    }

}
