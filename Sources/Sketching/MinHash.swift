//
//  MinHash.swift
//  Sketching
//
//  Created by Pierluigi D'Andrea on 03/03/2019.
//

import Foundation

public struct MinHash<Hasher: Hashing> {

    public var hashCount: Int {
        return hashValues.count
    }

    private var hashValues: [UInt32]

    public init(hashCount: Int) {
        self.hashValues = Array(repeating: .max, count: hashCount)
    }

    public mutating func insert<C: Collection>(_ v: C) where C.Element == UInt8 {
        let hashes = Hasher.hash(v, upperBound: UInt32.max)
        for (index, hash) in hashes.prefix(hashValues.count).enumerated() where hash < hashValues[index] {
            hashValues[index] = hash
        }
    }

    public func union(_ other: MinHash) -> MinHash {
        var union = self
        union.formUnion(other)
        return union
    }

    public mutating func formUnion(_ other: MinHash) {
        precondition(hashCount == other.hashCount, "Both MinHash must be initialized with the same hashCount")
        for i in 0..<hashCount {
            hashValues[i] = min(hashValues[i], other.hashValues[i])
        }
    }

    public func jaccard(_ other: MinHash) -> Double {
        precondition(hashCount == other.hashCount, "Both MinHash must be initialized with the same hashCount")

        var intersection = 0
        for i in 0..<hashCount where hashValues[i] == other.hashValues[i] {
            intersection += 1
        }

        return Double(intersection) / Double(hashCount)
    }

}
