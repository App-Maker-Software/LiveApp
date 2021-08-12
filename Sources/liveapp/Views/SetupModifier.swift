//
//  File.swift
//  
//
//  Created by Joseph Hinkle on 8/12/21.
//

import Foundation
import SwiftUI

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public extension View {
    #if STUB
    func setupLiveApp(localDependencies: [LocalDependency.Type], outline: (interpretedViews: Color, compiledViews: Color)?) -> Self {
        return self
    }
    #else
    func setupLiveApp(localDependencies: [LocalDependency.Type], outline: (interpretedViews: Color, compiledViews: Color)?) -> some View {
        if !LiveApp.hasSetup {
            if let outline = outline {
                LiveApp.outlineInterpretedViews(with: outline.interpretedViews, andCompiledViewsWith: outline.compiledViews)
            }
            #if INCLUDE_DEVELOPER_TOOLS
            LiveApp.configureHotReloadSession(localDependencies: localDependencies)
            #else
            // production live app mode todo
            fatalError()
            #endif
        }
        return LiveAppBirdView(baseView: self)
    }
    #endif
}
