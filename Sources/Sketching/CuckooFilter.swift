//
//  CuckooFilter.swift
//  Sketching
//
//  Created by Pierluigi D'Andrea on 08/03/2019.
//

import Foundation

public struct CuckooFilter<Hasher: IntegerHashing, Fingerprinter: Fingerprinting> {

    /// Number of buckets in the filter.
    public var capacity: Int {
        return buckets.count
    }

    /// Number of items in the filter.
    public private(set) var count: Int = 0

    /// Size, in bytes, of the fingerprints.
    private let fingerprintSize: Int
    private let evictionsLimit: Int

    /// Buckets for storing the fingerprints.
    private var buckets: [Bucket<[UInt8]>]

    /// Creates an empty `CuckooFilter`.
    ///
    /// - Precondition: `0 < fingerprintSize ≤ Fingerprinter.fingerprintSize`
    /// - Parameters:
    ///   - capacity: Number of buckets to use to store the fingerprints.
    ///   - bucketSize: Size of each bucket.
    ///   - fingerprintSize: Size of the fingerprints (number of bytes).
    ///   - evictionsLimit: Maximum number of evictions in the insert phase.
    public init(capacity: Int, bucketSize: Int = 4, fingerprintSize: Int = 1, evictionsLimit: Int = 500) {
        precondition(fingerprintSize > 0 && fingerprintSize <= Fingerprinter.fingerprintSize)
        self.fingerprintSize = fingerprintSize
        self.evictionsLimit = evictionsLimit
        self.buckets = Array(repeating: Bucket(size: bucketSize), count: capacity)
    }

    /// Inserts the given element in the filter.
    ///
    /// - Parameter newMember: An element to insert into the filter.
    /// - Returns: `true` if the element was added; `false` otherwise.
    public mutating func insert<S: Sequence>(_ newMember: S) -> Bool where S.Element == UInt8 {
        var fp = fingerprint(of: newMember)
        let i = index(for: newMember)
        let j = index(for: fp, previousIndex: i)

        if buckets[i].insert(fp) || buckets[j].insert(fp) {
            count += 1
            return true
        }

        var evictionIndex = Int(Bool.random() ? i : j)
        for _ in 0..<evictionsLimit {
            fp = buckets[evictionIndex].randomlyReplace(fp)
            evictionIndex = index(for: fp, previousIndex: i)
            if buckets[evictionIndex].insert(fp) {
                count += 1
                return true
            }
        }

        return false
    }

    /// Inserts the given element in the filter if it is not already present.
    ///
    /// - Parameter newMember: An element to insert into the filter.
    /// - Returns: `true` if the element was added or if it was already present; `false` otherwise.
    public mutating func insertIfNotPresent<S: Sequence>(_ newMember: S) -> Bool where S.Element == UInt8 {
        guard !contains(newMember) else {
            return true
        }

        return insert(newMember)
    }

    /// Returns a Boolean value that indicates whether the given element is possibly in the filter.
    ///
    /// - Parameter member: An element to look for in the filter.
    /// - Returns: `true` if `member` is possibly in the filter; `false` if certainly isn't.
    public func contains<S: Sequence>(_ member: S) -> Bool where S.Element == UInt8 {
        let fp = fingerprint(of: member)
        let i = index(for: member)
        let j = index(for: fp, previousIndex: i)
        return buckets[i].contains(fp) || buckets[j].contains(fp)
    }

    /// Removes the specified element from the filter.
    ///
    /// - Parameter member: The element to remove from the filter.
    /// - Returns: `true` if the element was removed; `false` otherwise.
    public mutating func remove<S: Sequence>(_ member: S) -> Bool where S.Element == UInt8 {
        let fp = fingerprint(of: member)
        let i = index(for: member)
        let j = index(for: fp, previousIndex: i)

        guard buckets[i].remove(fp) || buckets[j].remove(fp) else {
            return false
        }

        count -= 1
        return true
    }

    /// Calculates the fingerprint for the sequence of bytes `data`.
    ///
    /// - Parameter data: Sequence of bytes whose fingerprint to calculate.
    /// - Returns: Fingerprint of `data`.
    private func fingerprint<S: Sequence>(of data: S) -> [UInt8] where S.Element == UInt8 {
        return Array(Fingerprinter.fingerprint(data).prefix(fingerprintSize))
    }

    /// Gets the index for `data` in `buckets`.
    ///
    /// - Parameters:
    ///   - data: Data to insert or lookup.
    ///   - previousIndex: Index of the first bucket or 0 (default).
    /// - Returns: Index, in `buckets`, in which to store or lookup `data`.
    private func index<S: Sequence>(for data: S, previousIndex: Int = 0) -> Int where S.Element == UInt8 {
        let h = Hasher.hash(data)!
        return Int((Hasher.Digest(previousIndex) ^ h) % Hasher.Digest(capacity))
    }

}

extension CuckooFilter {

    /// Bucket to store the fingerprints of the items inserted in the `CuckooFilter`.
    private struct Bucket<T> where T: Equatable {

        private var storage: [T]
        private let size: Int
        private var isFull: Bool {
            return storage.count == size
        }

        fileprivate init(size: Int = 4) {
            self.size = size
            self.storage = []
            self.storage.reserveCapacity(size)
        }

        fileprivate mutating func insert(_ value: T) -> Bool {
            guard !isFull else {
                return false
            }

            storage.append(value)
            return true
        }

        fileprivate mutating func randomlyReplace(_ value: T) -> T {
            let evictedIndex = storage.indices.randomElement()!
            let evicted = storage[evictedIndex]
            storage[evictedIndex] = value
            return evicted
        }

        fileprivate mutating func remove(_ value: T) -> Bool {
            guard let index = storage.index(of: value) else {
                return false
            }

            storage.remove(at: index)
            return true
        }

        fileprivate func contains(_ value: T) -> Bool {
            return storage.contains(value)
        }

    }

}
