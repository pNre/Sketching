//
//  CuckooFilterTests.swift
//  SketchingTests
//
//  Created by Pierluigi D'Andrea on 08/03/2019.
//

import XCTest
@testable import Sketching

class CuckooFilterTests: XCTestCase {

    func testInsert() {
        var c = CuckooFilter<FNV1AHashing, FNV1AFingerprinting>(capacity: 4)
        XCTAssertTrue(c.insert("abc".utf8))
        XCTAssertTrue(c.insert("def".utf8))
        XCTAssertTrue(c.contains("abc".utf8))
        XCTAssertTrue(c.contains("def".utf8))
    }

    func testInsertIfNotPresent() {
        var c = CuckooFilter<FNV1AHashing, FNV1AFingerprinting>(capacity: 4)
        XCTAssertTrue(c.insertIfNotPresent("abc".utf8))
        XCTAssertTrue(c.insertIfNotPresent("abc".utf8))
        XCTAssertTrue(c.contains("abc".utf8))
    }

    func testContains() {
        var c = CuckooFilter<FNV1AHashing, FNV1AFingerprinting>(capacity: 4)
        for _ in 0..<16 {
            let s = randomBytes(8)
            if c.insert(s) {
                XCTAssertTrue(c.contains(s))
            }
        }
    }

    func testRemoval() {
        var c = CuckooFilter<FNV1AHashing, FNV1AFingerprinting>(capacity: 4)
        //  insert
        XCTAssertTrue(c.insert("abc".utf8))
        XCTAssertTrue(c.insert("def".utf8))
        //  test
        XCTAssertTrue(c.contains("abc".utf8))
        //  remove
        XCTAssertTrue(c.remove("abc".utf8))
        //  test again
        XCTAssertFalse(c.contains("abc".utf8))
        XCTAssertTrue(c.contains("def".utf8))
    }

}

extension CuckooFilterTests {

    private func randomBytes(_ length: Int) -> [UInt8] {
        return (0..<length).map { _ in UInt8.random(in: 0..<UInt8.max) }
    }

}
