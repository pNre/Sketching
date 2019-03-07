//
//  BitSet.swift
//  Sketching
//
//  Created by Pierluigi D'Andrea on 02/03/2019.
//

import Foundation
import Bridged

public struct BitSet {

    public let bitWidth: Int
    private var memory: [UInt64]

    public subscript(index: Int) -> Bool {
        get {
            precondition(index >= 0 && index < bitWidth)
            let cell = index / UInt64.bitWidth
            let offset = index % UInt64.bitWidth
            return memory[cell] >> offset & 1 == 1
        }
        set {
            precondition(index >= 0 && index < bitWidth)
            let cell = index / UInt64.bitWidth
            let offset = index % UInt64.bitWidth
            if newValue {
                memory[cell] |= (1 << offset)
            } else {
                memory[cell] &= ~(1 << offset)
            }
        }
    }

    public init(bitWidth width: Int) {
        bitWidth = width
        memory = Array(repeating: 0, count: (width - 1) / UInt64.bitWidth + 1)
    }

    public mutating func formConjunction(_ other: BitSet) {
        precondition(other.bitWidth == bitWidth, "To form a conjunction both BitSet must have the same bitWidth")
        for i in 0..<memory.count {
            memory[i] &= other.memory[i]
        }
    }

    public mutating func formDisjunction(_ other: BitSet) {
        precondition(other.bitWidth == bitWidth, "To form a disjunction both BitSet must have the same bitWidth")
        for i in 0..<memory.count {
            memory[i] |= other.memory[i]
        }
    }

    public mutating func negate() {
        for i in 0..<memory.count {
            memory[i] = ~memory[i]
        }
    }

    public func cardinality() -> Int {
        return memory.reduce(0, { (cardinality, cell) in cardinality + popcount(cell) })
    }

}

extension BitSet {

    public static func & (lhs: BitSet, rhs: BitSet) -> BitSet {
        var conjunction = lhs
        conjunction.formConjunction(rhs)
        return conjunction
    }

    public static func | (lhs: BitSet, rhs: BitSet) -> BitSet {
        var conjunction = lhs
        conjunction.formDisjunction(rhs)
        return conjunction
    }

    public static prefix func ~ (set: BitSet) -> BitSet {
        var negation = set
        negation.negate()
        return negation
    }

}

extension BitSet: Equatable {
    public static func == (lhs: BitSet, rhs: BitSet) -> Bool {
        return lhs.memory == rhs.memory
    }
}

extension BitSet: CustomStringConvertible {
    public var description: String {
        let value = memory
            .reversed()
            .map { val in String(repeating: "0", count: val.leadingZeroBitCount) + String(val, radix: 2) }
            .joined()
            .drop { $0 == "0" }

        return "BitSet (width=\(bitWidth), value=\(value))"
    }
}
