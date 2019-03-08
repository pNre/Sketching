//
//  BloomFilter.swift
//  Sketching
//
//  Created by Pierluigi D'Andrea on 06/03/2019.
//

import Foundation

public struct BloomFilter<Hasher: Hashing> {

    /// Number of hash functions
    public let hashCount: Int
    private var storage: BitSet

    /// Creates an empty `BloomFilter`
    ///
    /// - Parameters:
    ///   - width: Size of the underlaying `BitSet`.
    ///   - hashCount: Number of hash functions to use.
    public init(bitWidth width: Int, hashCount: Int) {
        self.storage = BitSet(bitWidth: width)
        self.hashCount = hashCount
    }

    /// Creates an empty `BloomFilter`.
    ///
    /// - Parameters:
    ///   - expectedCardinality: Expected item count.
    ///   - probabilityOfFalsePositives: Probability of false positives when testing whether an element is contained in the filter.
    public init(expectedCardinality: Int, probabilityOfFalsePositives: Double) {
        let params = BloomFilter.idealParameters(expectedCardinality: expectedCardinality, probabilityOfFalsePositives: probabilityOfFalsePositives)
        self.init(bitWidth: params.bitWidth, hashCount: params.hashCount)
    }

    /// Inserts the given element in the filter if it is not already present.
    ///
    /// - Parameter newMember: An element to insert into the filter.
    public mutating func insert<S: Sequence>(_ newMember: S) where S.Element == UInt8 {
        Hasher
            .hash(newMember, upperBound: UInt32(storage.bitWidth))
            .prefix(hashCount)
            .forEach { storage[Int($0)] = true }
    }

    /// Returns a Boolean value that indicates whether the given element is possibly in the filter.
    ///
    /// - Parameter member: An element to look for in the set.
    /// - Returns: `true` if `member` is possibly in the filter; `false` if certainly isn't.
    public func contains<S: Sequence>(_ member: S) -> Bool where S.Element == UInt8 {
        return Hasher
            .hash(member, upperBound: UInt32(storage.bitWidth))
            .prefix(hashCount)
            .allSatisfy { storage[Int($0)] }
    }

    /// Approximates the number of items contained in the filter.
    ///
    /// - Returns: Estimate of the number of items in the filter.
    public func cardinality() -> Double {
        let m = Double(storage.bitWidth)
        let k = Double(hashCount)
        let X = Double(storage.cardinality())
        return -(m / k) * log(1 - (X / m))
    }

    /// Approximates the probability of false positives when testing whether an item is contained in the filter.
    ///
    /// - Parameter cardinality: Number of items contained in the filter, or `nil` to use an estimate.
    /// - Returns: Estimate of the probability of false positives.
    public func probabilityOfFalsePositives(for cardinality: Int? = nil) -> Double {
        let m = Double(storage.bitWidth)
        let k = Double(hashCount)
        let n = cardinality.map(Double.init) ?? self.cardinality()
        return pow(1.0 - exp(-k * n / m), k)
    }

}

extension BloomFilter {

    /// Adds the elements of the given filter to the filter.
    ///
    /// - Parameter other: A filter of the same type as the current filter.
    public mutating func formUnion(_ other: BloomFilter) {
        precondition(other.hashCount == hashCount, "To form an union both BloomFilter must have the same number of hash functions")
        storage |= other.storage
    }

    /// Removes the elements of this filter that aren’t also in the given filter.
    ///
    /// - Parameter other: A filter of the same type as the current filter.
    public mutating func formIntersection(_ other: BloomFilter) {
        precondition(other.hashCount == hashCount, "To form an intersection both BloomFilter must have the same number of hash functions")
        storage &= other.storage
    }

}

extension BloomFilter {

    /// Approximates the `bitWidth` and `hashCount` for a filter that is expected to contain `expectedCardinality` items
    /// and have a `p` probability of false positives.
    ///
    /// - Parameters:
    ///   - expectedCardinality: Number of items that the filter is exptected to contain.
    ///   - p: Probability of false positives.
    /// - Returns: Pair of (`bitWidth`, `hashCount`) to use with the `init(bitWidth:hashCount:)` initializer.
    public static func idealParameters(expectedCardinality: Int,
                                       probabilityOfFalsePositives p: Double) -> (bitWidth: Int, hashCount: Int) {

        let n = Double(expectedCardinality)
        let m = -1 * n * log(p) / pow(log(2), 2)
        let k = m / n * log(2)
        return (Int(m.rounded(.up)), Int(k.rounded(.up)))

    }

}
