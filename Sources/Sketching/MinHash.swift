//
//  MinHash.swift
//  Sketching
//
//  Created by Pierluigi D'Andrea on 03/03/2019.
//

import Foundation

public struct MinHash<Hasher: IntegerHashing> {

    /// Number of hash functions used by the receiver.
    public var hashCount: Int {
        return hashValues.count
    }

    private var hashValues: [Hasher.Digest]

    /// Creates an empty `MinHash`.
    ///
    /// - Parameter hashCount: Number of hash functions to use.
    public init(hashCount: Int) {
        self.hashValues = Array(repeating: Hasher.Digest.max, count: hashCount)
    }

    /// Inserts the given element in the `MinHash` if it is not already present.
    ///
    /// - Parameter newMember: An element to insert into the `MinHash`.
    public mutating func insert<S: Sequence>(_ newMember: S) where S.Element == UInt8 {
        let hashes = Hasher.hash(newMember).makeIterator()
        for index in hashValues.indices {
            if let hash = hashes.next(), hash < hashValues[index] {
                hashValues[index] = hash
            }
        }
    }

    /// Returns a new `MinHash` resulting from the merge of the receiver and `other`.
    ///
    /// - Parameter other: A `MinHash` with the same `hashCount` as the receiver.
    /// - Returns: `MinHash` with the elements of both the receiver and `other`.
    public func union(_ other: MinHash) -> MinHash {
        var union = self
        union.formUnion(other)
        return union
    }

    /// Merges `other` into the receiver.
    ///
    /// - Precondition: Both the receiver and `other` must be initialized with the same `hashCount`.
    /// - Parameter other: A `MinHash`.
    public mutating func formUnion(_ other: MinHash) {
        precondition(hashCount == other.hashCount, "Both MinHash must be initialized with the same hashCount")
        for i in 0..<hashCount {
            hashValues[i] = min(hashValues[i], other.hashValues[i])
        }
    }

    /// Estimates the Jaccard similarity coefficient between the `MinHash` and the receiver.
    ///
    /// - Precondition: Both the receiver and `other` must be initialized with the same `hashCount`.
    /// - Parameter other: A `MinHash`.
    /// - Returns: Jaccard similarity coefficient.
    public func jaccard(_ other: MinHash) -> Double {
        precondition(hashCount == other.hashCount, "Both MinHash must be initialized with the same hashCount")

        var intersection = 0
        for (a, b) in zip(hashValues, other.hashValues) where a == b {
            intersection += 1
        }

        return Double(intersection) / Double(hashCount)
    }

}
