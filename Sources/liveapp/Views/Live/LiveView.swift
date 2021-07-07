//
//  LiveView.swift
//  LiveApp
//
//  Created by Joseph Hinkle on 4/6/21.
//

import SwiftUI
#if _BUILD_FROM_SOURCE
import SwiftInterpreterSource
#elseif _BUILD_FOR_APP_MAKER
import SwiftInterpreterPrivate
#else
import SwiftInterpreter
import SwiftInterpreterBinary
#endif
import ExceptionCatcher

#if PRODUCTION
public typealias LiveViewStub = LiveView
public protocol LiveView: LiveUI {
    associatedtype LiveBody = View
//    var source: LiveSource { get } // todo
    @ViewBuilder var liveBody: LiveBody { get }
}
#else
@available(macOS 10.15, watchOS 6.0, tvOS 13.0, iOS 13.0, *)
public protocol LiveView: LiveUI, _IsLiveView {
    associatedtype LiveBody = View
//    var source: LiveSource { get } // todo
    @ViewBuilder var liveBody: LiveBody { get }
}
public protocol _IsLiveView {}
#endif
@available(macOS 10.15, watchOS 6.0, tvOS 13.0, iOS 13.0, *)
public protocol LiveUI: View {
    var _internal: _InternalLiveUIData { get }
}

@available(macOS 10.15, watchOS 6.0, tvOS 13.0, iOS 13.0, *)
public struct _InternalLiveUIData {
    let compiledViewGetter: () -> AnyView
    let protocolName: String
}

@available(macOS 10.15, watchOS 6.0, tvOS 13.0, iOS 13.0, *)
extension LiveView where LiveBody: View {
    /*
    /// Force refreshes this live view to download the latest data from its remote repository.
    /// - Parameter upgrade: Dictates how the live view should upgrade to the latest version if a newer version is downloaded. Passing nil defaults to value in `LiveApp.Configuration.defaultUpgradeLogic`.
    static func refresh(upgrade: UpgradeLogic? = nil) {
        fatalError("todo")
    }
    */
//    public var source: LiveSource {
//        fatalError()
////        switch LiveApp.Configuration.projectDefaultSource {
////        case .none:
////            return .none
////        case .liveAppDataServer, .selfHost:
////            let structName = String(describing: Self.self)
////            return .remoteRepository(liveViewName: structName)
////        }
//    }
    public var _internal: _InternalLiveUIData {
        .init(compiledViewGetter: {
            #if INCLUDE_DEVELOPER_TOOLS
            if LiveApp.Configuration.shared.showOutlines, let outlineColor = LiveApp.Configuration.shared.outlineCompiledViewsColor as? Color {
                return .init(liveBody.border(outlineColor, width: 1))
            }
            return .init(liveBody)
            #else
            return .init(liveBody)
            #endif
        }, protocolName: "LiveView")
    }
}
@available(macOS 10.15, watchOS 6.0, tvOS 13.0, iOS 13.0, *)
extension LiveUI {
    #if INCLUDE_DEVELOPER_TOOLS
    func buildBody() throws -> AnyView {
        if _internal.protocolName == "UILiveViewRepresentablex" {
//            return AnyView(_internal.compiledViewGetter())
            return AnyView(Text("todo!").foregroundColor(.red))
        }
        return try ExceptionCatcher.catch {
            try buildStruct(
                for: self,
//                allowDebugMessages: LiveApp.Configuration.showDeveloperMessages,
                applyModifier: { interpretedView in
                    if LiveApp.Configuration.shared.showOutlines, let outlineColor =
                        LiveApp.Configuration.shared.outlineInterpretedViewsColor as? Color {
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
            try buildStruct(
                for: self,
                allowDebugMessages: false
            )
        }
    }
    #endif
    #if INCLUDE_DEVELOPER_TOOLS
    /// Recommended for development environments. When built with developer tools, any failure to interpreter the live data will notify the developer with a UI pop up. This helps developers catch configuration issues with Live App quickly.
    public var body: some View {
        RefreshableView<AnyView> {
            if LiveApp.Configuration.shared.autoHardReload && !LiveApp.destroyedViewAndNeedsToRebuild {
                if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
                    return AnyView(ProgressView())
                } else {
                    return AnyView(Image(systemName: "rays").resizable().frame(width: 20, height: 20))
                }
            }
            guard LiveApp.Configuration.shared.interpreterIsOn else {
                return AnyView(_internal.compiledViewGetter())
            }
            do {
                return try buildBody()
            } catch {
                return AnyView(Text("error").foregroundColor(.red))
    //            if LiveApp.Configuration.showDeveloperMessages {
    ////                return AnyView(_internal.compiledViewGetter().overlay(NotSetupView()))
    //                return AnyView(Text("error").foregroundColor(.red).overlay(NotSetupView()))
    //            } else {
    ////                return AnyView(_internal.compiledViewGetter())
    //                return AnyView(Text("error").foregroundColor(.red))
    //            }
            }
        }
    }
    #else
    /// Recommended for production environments. When built without developer tools, any failure to interpreter the live data will default to rendering the normal compiled SwiftUI view. This ensures that the end user never sees an error message regarding any Live App errors.
    public var body: some View {
//        (try? buildBody()) ?? AnyView(liveBody)
        (try? buildBody()) ?? AnyView(Text("FAILED!").foregroundColor(.red))
    }
    #endif
}
