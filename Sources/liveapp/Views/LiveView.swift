//
//  LiveView.swift
//  LiveApp
//
//  Created by Joseph Hinkle on 4/6/21.
//

import SwiftUI
#if _BUILD_FROM_SOURCE
import SwiftUIInterpreter
#else
import FlattenedSwiftUIInterpreter
#endif
import ExceptionCatcher

public protocol LiveView: View {
    associatedtype LiveBody = View
    var source: LiveSource { get }
    @ViewBuilder var liveBody: LiveBody { get }
}

extension LiveView where LiveBody: View {
    /// Force refreshes this live view to download the latest data from its remote repository.
    /// - Parameter upgrade: Dictates how the live view should upgrade to the latest version if a newer version is downloaded. Passing nil defaults to value in `LiveApp.Configuration.defaultUpgradeLogic`.
    static func refresh(upgrade: UpgradeLogic? = nil) {
        fatalError("todo")
    }
    public var source: LiveSource {
        fatalError()
//        switch LiveApp.Configuration.projectDefaultSource {
//        case .none:
//            return .none
//        case .liveAppDataServer, .selfHost:
//            let structName = String(describing: Self.self)
//            return .remoteRepository(liveViewName: structName)
//        }
    }
    #if INCLUDE_DEVELOPER_TOOLS
    func buildBody() throws -> AnyView {
        return try ExceptionCatcher.catch {
            return try buildViewStruct(
                for: self,
                allowDebugMessages: LiveApp.Configuration.showDeveloperMessages,
                getBackupView: {
                    var backupView = AnyView(liveBody)
                    if let outlineColor =
                        LiveApp.outlineCompiledViewsColor {
                        backupView = AnyView(backupView.border(outlineColor, width: 1))
                    }
                    if LiveApp.Configuration.showDeveloperMessages {
                        return AnyView(backupView.overlay(NotSetupView()))
                    } else {
                        return AnyView(backupView)
                    }
                },
                applyModifier: { interpretedView in
                    if let outlineColor =
                        LiveApp.outlineInterpretedViewsColor {
                        return AnyView(
                            interpretedView.border(outlineColor, width: 1)
                        )
                    } else {
                        return interpretedView
                    }
                }
            )
        }
    }
    #else
    func buildBody() throws -> AnyView {
        try ExceptionCatcher.catch {
            return try buildViewStruct(
                for: self,
                allowDebugMessages: false,
                getBackupView: {
                    AnyView(liveBody)
                }
            )
        }
    }
    #endif
    #if INCLUDE_DEVELOPER_TOOLS
    /// Recommended for development environments. When built with developer tools, any failure to interpreter the live data will notify the developer with a UI pop up. This helps developers catch configuration issues with Live App quickly.
    public var body: some View {
        do {
            return try buildBody()
        } catch {
            if LiveApp.Configuration.showDeveloperMessages {
                return AnyView(liveBody.overlay(NotSetupView()))
            } else {
                return AnyView(liveBody)
            }
        }
    }
    #else
    /// Recommended for production environments. When built without developer tools, any failure to interpreter the live data will default to rendering the normal compiled SwiftUI view. This ensures that the end user never sees an error message regarding any Live App errors.
    public var body: some View {
        (try? buildBody()) ?? AnyView(liveBody)
    }
    #endif
}
