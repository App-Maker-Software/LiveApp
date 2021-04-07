//
//  ClientVersion.swift
//  
//
//  Created by Joseph Hinkle on 4/7/21.
//

import UIKit

func makeClientVersionJSON() -> [String: Any] {
    return [
        "systemName": UIDevice.current.systemName,
        "systemVersion": {
            if let version = UIDevice.current.systemVersion.range(of: #"\b[0-9]+.[0-9]+(.[0-9])*\b"#, options: .regularExpression) {
                return String(UIDevice.current.systemVersion[version])
            }
            return UIDevice.current.systemVersion
        }(),
        "bundleIdentifier": Bundle.main.bundleIdentifier
    ]
}
