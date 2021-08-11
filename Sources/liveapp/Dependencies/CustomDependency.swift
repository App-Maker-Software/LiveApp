//
//  CustomDependency.swift
//  
//
//  Created by Joseph Hinkle on 4/10/21.
//

#if !STUB
import SwiftUI
#if _BUILD_FROM_SOURCE
import SwiftInterpreterSource
#elseif _BUILD_FOR_APP_MAKER
import SwiftInterpreterPrivate
#else
import SwiftInterpreter
import SwiftInterpreterBinary
#endif

/** Provides a same manner for implementing the Swift interpreter's InterpretableType protocol.
 It's dangerous to implement InterpretableType by itself, because the LiveApp server will not know which clients have what InterpretableTypes implemented. By only implementing the InterpretableType through LiveApp's LocalDependency, you get an auto-generated hash at compile-time which can be used to identify custom InterpretableTypes by their "_depHash" (dependency hash). A LiveApp server can then ask LiveApp clients to self-report what LocalDependencies they have by passing a list of their _depHashs. Then the server will know if a new LiveElement (i.e. LiveView, LiveFunc, LiveStruct, LiveClass, etc.) can be safely assumed to be supported by the LiveApp client.
 */
public protocol LocalDependency: _InterpretableType {
    /** A unique hash determined at compile-time which is calculated based on this local depedency's Swift AST--including extensions of it--AND the AST of the _InterpretableType implementation (this is required in cases where the underlying type isn't changing, but more of it is being exposed to the interpreter).
     Any change to the AST of this dependency--including name changes, orders of properties, etc., should trigger it's hash to be recalculated.
     Debug builds will trigger a runtime crash if it's found that the hash does not match what is expected.
     */
    static var _depHash: String { get }
    
}

public func addActiveCompilationConditionDependency(_ condition: String) {
    // TODO, add to dependencies for live server
    _addActiveCompilationCondition(condition)
}
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

#endif
