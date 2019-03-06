//
//  MinHash.swift
//  Sketching
//
//  Created by Pierluigi D'Andrea on 03/03/2019.
//

import Foundation

public struct MinHash<Hasher: Hashing> {

    public let permutationParameters: [PermutationParams]
    private var hashValues: [UInt32]

    public init(permutationParameterCount: Int) {
        self.hashValues = Array(repeating: .max, count: permutationParameterCount)
        self.permutationParameters = (0..<permutationParameterCount).map { _ in PermutationParams() }
    }

    public init(permutationParameters: [PermutationParams]) {
        self.hashValues = Array(repeating: .max, count: permutationParameters.count)
        self.permutationParameters = permutationParameters
    }

    public mutating func insert<C: Collection>(_ v: C) where C.Element == UInt8 {
        let hashes = Hasher.hash(v, upperBound: UInt32.max, count: hashValues.count)
        for i in 0..<hashValues.count {
            if hashes[i] < hashValues[i] {
                hashValues[i] = hashes[i]
            }
        }
    }

    public func union(_ other: MinHash) -> MinHash {
        var union = self
        union.formUnion(other)
        return union
    }

    public mutating func formUnion(_ other: MinHash) {
        precondition(permutationParameters == other.permutationParameters, "Both MinHash must be initialized with the same permutationParameters")
        for i in 0..<hashValues.count {
            hashValues[i] = min(hashValues[i], other.hashValues[i])
        }
    }

    public func jaccard(_ other: MinHash) -> Double {
        precondition(permutationParameters == other.permutationParameters, "Both MinHash must be initialized with the same permutationParameters")

        var intersection = 0
        for i in 0..<hashValues.count where hashValues[i] == other.hashValues[i] {
            intersection += 1
        }

        return Double(intersection) / Double(hashValues.count)
    }

}

extension MinHash {

    public struct PermutationParams: Equatable {
        private let a = UInt32.random(in: 1...UInt32.max)
        private let b = UInt32.random(in: 0...UInt32.max)

        public func computePermution(for x: UInt32) -> UInt32 {
            let prime: UInt64 = (1 << 61) - 1
            return UInt32(((UInt64(a) * UInt64(x) + UInt64(b)) % prime) % UInt64(UInt32.max))
        }
    }

}
