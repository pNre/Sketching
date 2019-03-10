//
//  CountMin.swift
//  Sketching
//
//  Created by Pierluigi D'Andrea on 10/03/2019.
//

import Foundation

public struct CountMin<Hasher: IntegerHashing> {

    /// Number of rows in the count matrix.
    public let depth: Int

    /// Number of columns in the count matrix.
    public let width: Int

    /// 2d array holding the counts.
    private var count: [[UInt64]]

    /// Creates an empty `CountMin`.
    ///
    /// - Parameters:
    ///   - depth: Number of rows in the count matrix.
    ///   - width: Number of columns in the count matrix.
    public init(depth: Int, width: Int) {
        precondition(depth > 0, "depth must be > 0")
        precondition(width > 0, "width must be > 0")
        self.depth = depth
        self.width = width
        self.count = Array(repeating: Array(repeating: 0, count: width), count: depth)
    }

    /// Creates an empty `CountMin`.
    ///
    /// - Parameters:
    ///   - epsilon: Factor of relative accuracy.
    ///   - delta: Probability of relative accuracy.
    public init(epsilon: Double, delta: Double) {
        (depth, width) = CountMin.idealParameters(epsilon: epsilon, delta: delta)
        count = Array(repeating: Array(repeating: 0, count: width), count: depth)
    }

    /// Updates the receiver with `value` new occurrences of `key`.
    ///
    /// - Parameters:
    ///   - key: Key to update.
    ///   - value: Number of occurrences.
    public mutating func update<S: Sequence>(_ key: S, value: UInt64) where S.Element == UInt8 {
        let indices = Hasher.hash(key, upperBound: Hasher.Digest(width)).lazy.map(Int.init)
        for (r, c) in zip(0..<depth, indices) {
            count[r][c] += value
        }
    }

    /// Estimates the number of occurrences of `key`.
    ///
    /// - Parameter key: Key to count the occurrences of.
    /// - Returns: Estimation of the number of times `key` has ocurred.
    public func estimateCount<S: Sequence>(for key: S) -> UInt64 where S.Element == UInt8 {
        let indices = Hasher.hash(key, upperBound: Hasher.Digest(width)).lazy.map(Int.init)
        var m = UInt64.max
        for (r, c) in zip(0..<depth, indices) {
            m = min(m, count[r][c])
        }

        return m
    }

    /// Returns a new `CountMin` resulting from the union of the receiver and `other`.
    ///
    /// - Precondition: Both `CountMin` must have the same depth and width.
    /// - Parameter other: `CountMin` of the same type as the receiver.
    /// - Returns: `CountMin` representing the union of both the receiver and `other`.
    public func union(_ other: CountMin) -> CountMin {
        var union = self
        union.formUnion(other)
        return union
    }

    /// Adds the counts of the given `CountMin` to the receiver.
    ///
    /// - Precondition: Both `CountMin` must have the same depth and width.
    /// - Parameter other: `CountMin` of the same type as the receiver.
    public mutating func formUnion(_ other: CountMin) {
        precondition(other.depth == depth, "To form an union both CountMin must have the same depth")
        precondition(other.width == width, "To form an union both CountMin must have the same width")
        for r in 0..<depth {
            for c in 0..<width {
                count[r][c] += other.count[r][c]
            }
        }
    }

}

extension CountMin {

    /// Approximates the `depth` and `width` for a `CountMin` whose relative accuracy is within a factor of `epsilon` with probability `delta`.
    ///
    /// - Precondition:
    ///   - `0 < epsilon < 1`
    ///   - `0 < delta < 1`
    /// - Parameters:
    ///   - epsilon: Factor of relative accuracy.
    ///   - delta: Probability of relative accuracy.
    /// - Returns: `depth` and `width` to use with the `init(depth:width:)` initializer.
    public static func idealParameters(epsilon: Double, delta: Double) -> (depth: Int, width: Int) {
        precondition(epsilon > 0 && epsilon < 1, "epsilon must be > 0 && < 1")
        precondition(delta > 0 && delta < 1, "delta must be > 0 && < 1")

        let depth = log(1.0 - delta) / log(0.5)
        let width = 2.0 / epsilon
        return (Int(depth.rounded(.up)), Int(width.rounded(.up)))
    }

}
