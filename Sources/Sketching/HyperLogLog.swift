//
//  HyperLogLog.swift
//  Sketching
//
//  Created by Pierluigi D'Andrea on 02/03/2019.
//

import Foundation

public struct HyperLogLog<Hasher: Hashing> {

    /// Precision.
    private let b: Int

    /// Number of registers.
    private let m: Int

    /// Internal state.
    private var registers: [UInt8]

    /// Creates an empty `HyperLogLog`.
    ///
    /// - Precondition: `4 ≤ b ≤ 16`
    /// - Parameter b: Determines the number of registers to use, `2^b`.
    public init(precision b: Int = 8) {
        precondition(b >= 4 && b <= 16)
        self.b = b
        self.m = 1 << b
        self.registers = Array(repeating: 0, count: m)
    }

    /// Inserts the given element in the `HyperLogLog`.
    ///
    /// - Parameter newMember: An element to insert into the `HyperLogLog`.
    public mutating func insert<S: Sequence>(_ newMember: S) where S.Element == UInt8 {
        let x = Hasher.hash(newMember, upperBound: UInt32.max).makeIterator().next()!
        let index = 1 + Int(x & UInt32(m - 1))
        let w = x >> b
        let pw = w == 0 ? 0 : UInt8(w.leadingZeroBitCount + 1)
        registers[index] = max(registers[index], pw)
    }

    /// Approximates the number of items contained in the set.
    ///
    /// - Returns: Estimate of the number of items in the set.
    public func cardinality() -> Double {
        let alpha: Double = {
            switch m {
            case 4:
                return 0.673
            case 5:
                return 0.697
            case 6:
                return 0.709
            default:
                return 0.7213 / (1.0 + 1.079 / Double(m))
            }
        }()

        let r = registers.reduce(0, { (sum, x) in sum + pow(2, -Double(x)) })
        let E = alpha * Double(m * m) / r

        if E < (5.0 / 2.0) * Double(m) {
            let V = registers.filter { $0 == 0 }.count
            guard V > 0 else {
                return E
            }

            return Double(m) * log(Double(m) / Double(V))
        } else if E <= Double(1 << 32) / 30.0 {
            return E
        }

        return -Double(1 << 32) * log(1.0 - E / Double(1 << 32))
    }

    /// Returns a new `HyperLogLog` resulting from the union of the receiver and `other`.
    ///
    /// - Precondition: Both `HyperLogLog` must have the same number of registers.
    /// - Parameter other: An `HyperLogLog` with the same number of registers as the receiver.
    /// - Returns: `HyperLogLog` representing the union of both the receiver and `other`.
    public func union(_ other: HyperLogLog) -> HyperLogLog {
        var union = self
        union.formUnion(other)
        return union
    }

    /// Adds the elements of the given set to the receiver.
    ///
    /// - Precondition: Both `HyperLogLog` must have the same number of registers.
    /// - Parameter other: An `HyperLogLog` of the same type as the receiver.
    public mutating func formUnion(_ other: HyperLogLog) {
        precondition(other.m == m, "To form an union both HyperLogLog must have the same number of registers")
        for i in 0..<registers.count {
            registers[i] = max(registers[i], other.registers[i])
        }
    }

}
