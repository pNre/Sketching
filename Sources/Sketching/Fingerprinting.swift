//
//  Fingerprinting.swift
//  Sketching
//
//  Created by Pierluigi D'Andrea on 08/03/2019.
//

import Foundation

public protocol Fingerprinting {

    /// Size, in bytes, of the fingerprint
    static var fingerprintSize: Int { get }

    /// Creates a fingerprint for an arbitrary sequence of bytes.
    ///
    /// - Parameter value: Sequence of bytes to fingerprint.
    /// - Returns: Fingerprint.
    static func fingerprint<S: Sequence>(_ value: S) -> [UInt8] where S.Element == UInt8

}
