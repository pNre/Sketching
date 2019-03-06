//
//  Hashing.swift
//  SketchingTests
//
//  Created by Pierluigi D'Andrea on 05/03/2019.
//

import Foundation
@testable import Sketching

struct FNV1AHashing: Hashing {
    static func hash<C: Collection>(_ val: C, upperBound: UInt32, count: Int) -> [UInt32] where C.Element == UInt8 {
        let a = hash(val, offsetBasis: 2166136261)
        let b = hash(val, offsetBasis: 3560826425)
        return (1...count).map { i in UInt32((UInt64(a) + UInt64(i) * UInt64(b)) % UInt64(upperBound)) }
    }

    private static func hash<C: Collection>(_ val: C, offsetBasis: UInt32) -> UInt32 where C.Element == UInt8 {
        var hash: UInt32 = offsetBasis
        for byte in val {
            hash ^= UInt32(byte)
            hash = hash &* 16777619
        }
        return hash
    }
}
