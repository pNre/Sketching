//
//  Hashing.swift
//  Sketching
//
//  Created by Pierluigi D'Andrea on 02/03/2019.
//

import Foundation

public protocol Hashing {
    static func hash<C: Collection>(_ val: C, upperBound: UInt32, count: Int) -> [UInt32] where C.Element == UInt8
}
