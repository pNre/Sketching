//
//  Hashing.swift
//  Sketching
//
//  Created by Pierluigi D'Andrea on 02/03/2019.
//

import Foundation

public protocol Hashing {

    associatedtype Digest

    /// Size, in bits, of the hash digest
    static var digestBitWidth: Int { get }

    /// Map an arbitrary sequence of bytes to a sequence of hash values.
    ///
    /// - Parameter value: Sequence of bytes to hash.
    /// - Returns: Sequence of digests of `data`.
    static func hash<S: Sequence>(_ value: S) -> AnySequence<Digest> where S.Element == UInt8

}

extension Hashing {

    /// Map an arbitrary sequence of bytes to a digest.
    ///
    /// - Parameter value: Sequence of bytes to hash.
    /// - Returns: First digest of `value`.
    static func hash<S: Sequence>(_ value: S) -> Digest? where S.Element == UInt8 {
        return (hash(value) as AnySequence<Digest>).makeIterator().next()
    }

}

public protocol IntegerHashing: Hashing where Digest: FixedWidthInteger {

    /// Map an arbitrary sequence of bytes to a sequence of integer hash values.
    ///
    /// - Parameters:
    ///   - value: Sequence of bytes to hash.
    ///   - upperBound: Max value of each hash.
    /// - Returns: Sequence of integer hashes of `data`.
    static func hash<S: Sequence>(_ value: S, upperBound: Digest) -> AnySequence<Digest> where S.Element == UInt8

}

