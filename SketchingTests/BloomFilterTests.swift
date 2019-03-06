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

}
