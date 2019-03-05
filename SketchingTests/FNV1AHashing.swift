//
//  FNV1AHashing.swift
//  SketchingTests
//
//  Created by Pierluigi D'Andrea on 05/03/2019.
//

import Foundation
@testable import Sketching

struct FNV1AHashing: Hashing {
    static func hash<C: Collection>(_ val: C) -> UInt32 where C.Element == UInt8 {
        var hash: UInt32 = 2166136261
        for byte in val {
            hash ^= UInt32(byte)
            hash = hash &* 16777619
        }
        return hash
    }
}
