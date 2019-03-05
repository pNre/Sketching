//
//  MinHash.swift
//  Sketching
//
//  Created by Pierluigi D'Andrea on 03/03/2019.
//

import Foundation

public struct MinHash<Hasher: Hashing> {

    private static var maxHash: UInt32 {
        return .max
    }

    public let state: [PermutationParams<Hasher>]
    private var hashValues: [UInt32]

    public init(permutationCount: Int) {
        self.hashValues = Array(repeating: MinHash.maxHash, count: permutationCount)
        self.state = (0..<permutationCount).map { _ in PermutationParams() }
    }

    public init(state: [PermutationParams<Hasher>]) {
        self.hashValues = Array(repeating: MinHash.maxHash, count: state.count)
        self.state = state
    }

    public mutating func insert<C: Collection>(_ v: C) where C.Element == UInt8 {
        let hashedValue = Hasher.hash(v)
        for i in 0..<hashValues.count {
            let perm = state[i].computePermution(for: hashedValue)
            if perm < hashValues[i] {
                hashValues[i] = perm
            }
        }
    }

    public func union(_ other: MinHash) -> MinHash {
        var union = self
        union.formUnion(other)
        return union
    }

    public mutating func formUnion(_ other: MinHash) {
        precondition(state == other.state, "Both MinHash must be initialized with the same state")
        for i in 0..<hashValues.count {
            hashValues[i] = min(hashValues[i], other.hashValues[i])
        }
    }

    public func jaccard(_ other: MinHash) -> Double {
        precondition(state == other.state, "Both MinHash must be initialized with the same state")

        var intersection = 0
        for i in 0..<hashValues.count where hashValues[i] == other.hashValues[i] {
            intersection += 1
        }

        return Double(intersection) / Double(hashValues.count)
    }

}

extension MinHash {

    public struct PermutationParams<Hasher: Hashing>: Equatable {
        private let a = UInt32.random(in: 1...MinHash.maxHash)
        private let b = UInt32.random(in: 0...MinHash.maxHash)

        public func computePermution(for x: UInt32) -> UInt32 {
            let prime: UInt64 = (1 << 61) - 1
            return UInt32(((UInt64(a) * UInt64(x) + UInt64(b)) % prime) % UInt64(MinHash.maxHash))
        }
    }

}
