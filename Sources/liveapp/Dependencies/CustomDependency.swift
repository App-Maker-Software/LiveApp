//
//  CustomDependency.swift
//  
//
//  Created by Joseph Hinkle on 4/10/21.
//

import SwiftUI
/*
extension LiveApp {
    public final class Dependencies {
        public static func addCustomDependency(_ dependency: CustomDependency, identifiedBy identifier: DependencyIdentifier = .InitHash()) {
            
        }
    }
}

public struct CustomDependency {
    public static func UIViewRepresentable<T: UIViewRepresentable>(_ view: T.Type) -> CustomDependency {
        // todo
        return .init()
    }
    public static func NonLiveView<T: View>(_ view: T.Type) -> CustomDependency {
        #if !PRODUCTION
        if view is _IsLiveView.Type {
            fatalError("You should not add a LiveView as a custom dependency")
        }
        #endif
        // todo
        return .init()
    }
}

public struct DependencyIdentifier {
    let dependencyId: String?
    let automatic: Automatic?
    public static func Version(_ versionNumber: Int) -> DependencyIdentifier {
        .init(dependencyId: "version \(versionNumber)", automatic: nil)
    }
    public static func InitHash() -> DependencyIdentifier {
        .init(dependencyId: nil, automatic: .InitHash)
    }
    public static func HashOfEntireStruct() -> DependencyIdentifier {
        .init(dependencyId: nil, automatic: .HashOfEntireStruct)
    }
    enum Automatic {
        case InitHash, HashOfEntireStruct
    }
}

*/
