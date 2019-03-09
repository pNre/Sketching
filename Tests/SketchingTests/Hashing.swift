//
//  Hashing.swift
//  SketchingTests
//
//  Created by Pierluigi D'Andrea on 05/03/2019.
//

import Foundation
@testable import Sketching

struct FNV1AHashing: IntegerHashing {
    static var digestBitWidth: Int {
        return UInt32.bitWidth
    }

    static func hash<S>(_ value: S) -> AnySequence<UInt32> where S : Sequence, S.Element == UInt8 {
        return hash(value, upperBound: .max)
    }

    static func hash<S>(_ value: S, upperBound: UInt32) -> AnySequence<UInt32> where S : Sequence, S.Element == UInt8 {
        let a = hash(value, offsetBasis: 2166136261)
        let b = hash(value, offsetBasis: 3560826425)
        return AnySequence(sequence(state: 1) { (i) -> UInt32? in
            let hash = UInt32((UInt64(a) + UInt64(i) * UInt64(b)) % UInt64(upperBound))
            i += 1
            return hash
        })
    }

    private static func hash<S: Sequence>(_ val: S, offsetBasis: UInt32) -> UInt32 where S.Element == UInt8 {
        var hash: UInt32 = offsetBasis
        for byte in val {
            hash ^= UInt32(byte)
            hash = hash &* 16777619
        }
        return hash
    }
}
