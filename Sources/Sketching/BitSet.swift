//
//  BitSet.swift
//  Sketching
//
//  Created by Pierluigi D'Andrea on 02/03/2019.
//

import Foundation
import Bridged

public struct BitSet: Codable {

    /// The number of bits used for the representation of the `BitSet`.
    public let bitWidth: Int

    /// Stores the bits packed in UInt64 values.
    private var storage: [UInt64]

    /// Accesses the bit at the specified position.
    ///
    /// - Parameter index: The position of the bit to access.
    public subscript(index: Int) -> Bool {
        get {
            precondition(index >= 0 && index < bitWidth)
            let cell = index / UInt64.bitWidth
            let offset = index % UInt64.bitWidth
            return storage[cell] >> offset & 1 == 1
        }
        set {
            precondition(index >= 0 && index < bitWidth)
            let cell = index / UInt64.bitWidth
            let offset = index % UInt64.bitWidth
            if newValue {
                storage[cell] |= (1 << offset)
            } else {
                storage[cell] &= ~(1 << offset)
            }
        }
    }

    /// Creates a `BitSet`.
    ///
    /// - Parameter width: The number of bits that this instance of `BitSet` is going to contain.
    public init(bitWidth width: Int) {
        bitWidth = width
        storage = Array(repeating: 0, count: (width - 1) / UInt64.bitWidth + 1)
    }

    /// Performs a bitwise `AND` operation between the `BitSet` and the receiver.
    ///
    /// - Parameter other: A `BitSet`
    public mutating func formConjunction(_ other: BitSet) {
        precondition(other.bitWidth == bitWidth, "To form a conjunction both BitSet must have the same bitWidth")
        for i in storage.indices {
            storage[i] &= other.storage[i]
        }
    }

    /// Performs a bitwise `OR` operation between the `BitSet` and the receiver.
    ///
    /// - Parameter other: A `BitSet`
    public mutating func formDisjunction(_ other: BitSet) {
        precondition(other.bitWidth == bitWidth, "To form a disjunction both BitSet must have the same bitWidth")
        for i in storage.indices {
            storage[i] |= other.storage[i]
        }
    }

    /// Negates each bit in the receiver.
    public mutating func negate() {
        for i in storage.indices {
            storage[i] = ~storage[i]
        }
    }

    /// Counts the number of 1-bits in the receiver.
    ///
    /// - Returns: Number of 1-bits in the receiver.
    public func cardinality() -> Int {
        return storage.reduce(0, { (cardinality, cell) in cardinality + popcount(cell) })
    }

}

extension BitSet {

    /// Returns the result of performing a bitwise `AND` operation on the two given values.
    ///
    /// - Parameters:
    ///   - lhs: A `BitSet`
    ///   - rhs: Another `BitSet`
    /// - Returns: `BitSet` resulting from the bitwise `AND` on `lhs` and `rhs`.
    public static func & (lhs: BitSet, rhs: BitSet) -> BitSet {
        var conjunction = lhs
        conjunction.formConjunction(rhs)
        return conjunction
    }

    /// Stores the result of performing a bitwise `AND` operation on the two given values in the left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: A `BitSet`
    ///   - rhs: Another `BitSet`
    public static func &= (lhs: inout BitSet, rhs: BitSet) {
        lhs = lhs & rhs
    }

    /// Returns the result of performing a bitwise `OR` operation on the two given values.
    ///
    /// - Parameters:
    ///   - lhs: A `BitSet`
    ///   - rhs: Another `BitSet`
    /// - Returns: `BitSet` resulting from the bitwise `OR` on `lhs` and `rhs`.
    public static func | (lhs: BitSet, rhs: BitSet) -> BitSet {
        var conjunction = lhs
        conjunction.formDisjunction(rhs)
        return conjunction
    }

    /// Stores the result of performing a bitwise `OR` operation on the two given values in the left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: A `BitSet`
    ///   - rhs: Another `BitSet`
    public static func |= (lhs: inout BitSet, rhs: BitSet) {
        lhs = lhs | rhs
    }

    /// Returns a `BitSet` with the inverse of the bits set in the argument.
    ///
    /// - Parameter set: `BitSet` whose bits to invert.
    /// - Returns: `BitSet` with the inverted bits.
    public static prefix func ~ (set: BitSet) -> BitSet {
        var negation = set
        negation.negate()
        return negation
    }

}

extension BitSet: Equatable {

    public static func == (lhs: BitSet, rhs: BitSet) -> Bool {
        return lhs.storage == rhs.storage
    }

}

extension BitSet: CustomStringConvertible {

    public var description: String {
        let value = storage
            .reversed()
            .map { val in String(repeating: "0", count: val.leadingZeroBitCount) + String(val, radix: 2) }
            .joined()
            .drop { $0 == "0" }

        return "BitSet (width=\(bitWidth), value=\(value))"
    }

}
