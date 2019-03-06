//
//  MinHashTests.swift
//  SketchingTests
//
//  Created by Pierluigi D'Andrea on 05/03/2019.
//

import XCTest
@testable import Sketching

class MinHashTests: XCTestCase {

    func testStateInitialization() {
        let h = MinHash<FNV1AHashing>(permutationParameterCount: 64)
        XCTAssertEqual(h.permutationParameters.count, 64)
    }

    func testDistanceForEqualSets() {
        var a = MinHash<FNV1AHashing>(permutationParameterCount: 64)
        a.insert("a".utf8)
        a.insert("b".utf8)
        a.insert("c".utf8)

        XCTAssertEqual(a.jaccard(a), 1.0)
    }

    func testDistanceForDifferentSets() {
        var a = MinHash<FNV1AHashing>(permutationParameterCount: 64)
        a.insert("a".utf8)
        a.insert("b".utf8)
        a.insert("c".utf8)

        var b = MinHash<FNV1AHashing>(permutationParameters: a.permutationParameters)
        b.insert("a".utf8)
        b.insert("b".utf8)

        XCTAssertLessThan(a.jaccard(b), 1.0)
        XCTAssertGreaterThan(a.jaccard(b), 0.0)
    }

    func testUnion() {
        var a = MinHash<FNV1AHashing>(permutationParameterCount: 64)
        a.insert("a".utf8)
        a.insert("b".utf8)
        a.insert("c".utf8)

        var b = MinHash<FNV1AHashing>(permutationParameters: a.permutationParameters)
        b.insert("a".utf8)
        b.insert("b".utf8)

        let u = a.union(b)
        XCTAssertEqual(u.jaccard(a), 1.0)
    }

}
