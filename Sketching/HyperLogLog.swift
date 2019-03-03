//
//  HyperLogLog.swift
//  Sketching
//
//  Created by Pierluigi D'Andrea on 02/03/2019.
//

import Foundation

public struct HyperLogLog<Hasher: Hashing> {

    private let p: Int
    private let m: Int
    private var registers: [UInt8]
    private var maxRank: Int {
        return 32 - p
    }

    private var alpha: Double {
        switch p {
        case 4:
            return 0.673
        case 5:
            return 0.697
        case 6:
            return 0.709
        default:
            return 0.7213 / (1.0 + 1.079 / Double(1 << p))
        }
    }

    public init(precision: Int = 8) {
        precondition(precision >= 4 && precision <= 16)
        p = precision
        m = 1 << precision
        registers = Array(repeating: 0, count: m)
    }

    private init(state: [UInt8]) {
        m = state.count
        p = m.bitWidth - m.leadingZeroBitCount - 1
        registers = state
    }

    public mutating func insert<C: Collection>(_ v: C) where C.Element == UInt8 {
        let hashedValue = Hasher.hash(v)
        let index = hashedValue & UInt32(m - 1)
        let bits = hashedValue >> p
        registers[Int(index)] = max(registers[Int(index)], UInt8(rank(of: bits)))
    }

    public func cardinality() -> Double {
        let r = registers.reduce(0, { (sum, x) in sum + pow(2, -Double(x)) })
        let E = alpha * Double(m * m) / r

        if E <= (5.0 / 2.0) * Double(m) {
            let V = registers.filter { $0 == 0 }.count
            if V > 0 {
                return Double(m) * log(Double(m) / Double(V))
            } else {
                return E
            }
        } else if E <= (1.0 / 30.0) * Double(1 << 32) {
            return E
        }

        return -Double(1 << 32) * log(1.0 - E / Double(1 << 32))
    }

    public func union(_ other: HyperLogLog) -> HyperLogLog {
        var union = self
        union.formUnion(other)
        return union
    }

    public mutating func formUnion(_ other: HyperLogLog) {
        precondition(other.m == m, "To form an union both HyperLogLog must have the same number of registers")
        for i in 0..<registers.count {
            registers[i] = max(registers[i], other.registers[i])
        }
    }

    private func rank(of value: UInt32) -> Int {
        let r = maxRank - (value.bitWidth - value.leadingZeroBitCount) + 1
        precondition(r > 0)
        return r
    }

}
