//
//  BloomFilter.swift
//  Sketching
//
//  Created by Pierluigi D'Andrea on 06/03/2019.
//

import Foundation

public struct BloomFilter<Hasher: Hashing> {

    public let hashCount: Int
    private var storage: BitSet

    public init(bitWidth width: Int, hashCount: Int) {
        self.storage = BitSet(bitWidth: width)
        self.hashCount = hashCount
    }

    public init(expectedCardinality: Int, probabilityOfFalsePositives: Double) {
        let params = BloomFilter.idealParameters(expectedCardinality: expectedCardinality, probabilityOfFalsePositives: probabilityOfFalsePositives)
        self.init(bitWidth: params.bitWidth, hashCount: params.hashCount)
    }

    public mutating func insert<C: Collection>(_ v: C) where C.Element == UInt8 {
        let hashes = Hasher.hash(v, upperBound: UInt32(storage.bitWidth), count: hashCount)
        for h in hashes {
            storage[Int(h)] = true
        }
    }

    public func contains<C: Collection>(_ v: C) -> Bool where C.Element == UInt8 {
        let hashes = Hasher.hash(v, upperBound: UInt32(storage.bitWidth), count: hashCount)
        for h in hashes {
            if !storage[Int(h)] {
                return false
            }
        }

        return true
    }

    public func cardinality() -> Double {
        let m = Double(storage.bitWidth)
        let k = Double(hashCount)
        let X = Double(storage.cardinality())
        return -(m / k) * log(1 - (X / m))
    }

    public func probabilityOfFalsePositives(for cardinality: Int? = nil) -> Double {
        let m = Double(storage.bitWidth)
        let k = Double(hashCount)
        let n = cardinality.map(Double.init) ?? self.cardinality()
        return pow(1.0 - exp(-k * n / m), k)
    }

}

extension BloomFilter {

    public static func idealParameters(expectedCardinality: Int, probabilityOfFalsePositives p: Double) -> (bitWidth: Int, hashCount: Int) {
        let n = Double(expectedCardinality)
        let m = -1 * n * log(p) / pow(log(2), 2)
        let k = m / n * log(2)
        return (Int(m.rounded(.up)), Int(k.rounded(.up)))
    }

}
