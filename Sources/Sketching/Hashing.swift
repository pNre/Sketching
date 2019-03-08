//
//  Hashing.swift
//  Sketching
//
//  Created by Pierluigi D'Andrea on 02/03/2019.
//

import Foundation

public protocol Hashing {

    /// Map an arbitrary sequence of bytes to `hashCount` unsigned integer hash values.
    ///
    /// - Parameters:
    ///   - value: Sequence of bytes to hash.
    ///   - upperBound: Max value of each hash.
    ///   - hashCount: Number of hashes to return.
    /// - Returns: `hashCount` hashes of `data`.
    static func hash<S: Sequence>(_ value: S, upperBound: UInt32, hashCount: Int) -> [UInt32] where S.Element == UInt8

}
