//
//  Fingerprinting.swift
//  SketchingTests
//
//  Created by Pierluigi D'Andrea on 08/03/2019.
//

import Foundation
@testable import Sketching

struct FNV1AFingerprinting: Fingerprinting {

    static var fingerprintSize: Int {
        return 1
    }

    static func fingerprint<S>(_ value: S) -> [UInt8] where S : Sequence, S.Element == UInt8 {
        return [UInt8(FNV1AHashing.hash(value)! & 0xFF)]
    }

}
