//
//  BitSetTests.swift
//  SketchingTests
//
//  Created by Pierluigi D'Andrea on 02/03/2019.
//

import XCTest
@testable import Sketching

class BitSetTests: XCTestCase {

    func testBitWidth() {
        let bitSet = BitSet(bitWidth: 50)
        XCTAssertEqual(bitSet.bitWidth, 50)
    }

    func testSettingClearingBits() {
        var bitSet = BitSet(bitWidth: 50)

        //  set
        var indices = IndexSet()
        (0..<bitSet.bitWidth).forEach { _ in
            indices.insert(Int.random(in: 0..<bitSet.bitWidth))
        }

        indices.forEach {
            bitSet[$0] = true
        }

        indices.forEach {
            XCTAssertTrue(bitSet[$0])
        }

        //  clear
        indices.removeAll()
        (0..<bitSet.bitWidth).forEach { _ in
            indices.insert(Int.random(in: 0..<bitSet.bitWidth))
        }

        indices.forEach {
            bitSet[$0] = false
        }

        indices.forEach {
            XCTAssertFalse(bitSet[$0])
        }
    }

    func testCardinality() {
        var bitSet = BitSet(bitWidth: 50)

        //  when empty
        XCTAssertEqual(bitSet.cardinality(), 0)

        //  when filled
        var indices = IndexSet()
        (0..<bitSet.bitWidth).forEach { _ in
            indices.insert(Int.random(in: 0..<bitSet.bitWidth))
        }

        indices.forEach {
            bitSet[$0] = true
        }

        XCTAssertEqual(bitSet.cardinality(), indices.count)
    }

    func testAnd() {
        var bitSet = BitSet(bitWidth: 128)
        bitSet[0] = true
        bitSet[2] = true
        bitSet[64] = true

        var other = BitSet(bitWidth: bitSet.bitWidth)
        other[1] = true

        XCTAssertEqual(bitSet & bitSet, bitSet)
        XCTAssertEqual(bitSet & other, BitSet(bitWidth: bitSet.bitWidth))
    }

    func testOr() {
        var bitSet = BitSet(bitWidth: 50)
        bitSet[0] = true
        bitSet[2] = true

        var other = BitSet(bitWidth: bitSet.bitWidth)
        other[1] = true

        var disjunction = BitSet(bitWidth: bitSet.bitWidth)
        disjunction[0] = true
        disjunction[1] = true
        disjunction[2] = true

        XCTAssertEqual(bitSet | bitSet, bitSet)
        XCTAssertEqual(bitSet | other, disjunction)
    }

    func testNegation() {
        var bitSet = BitSet(bitWidth: 50)
        bitSet[0] = true
        bitSet[1] = true

        let negated = ~bitSet

        for i in 0..<2 {
            XCTAssertFalse(negated[i])
        }

        for i in 2..<negated.bitWidth {
            XCTAssertTrue(negated[i])
        }

        let other = ~BitSet(bitWidth: bitSet.bitWidth)

        for i in 0..<other.bitWidth {
            XCTAssertTrue(other[i])
        }
    }

}
