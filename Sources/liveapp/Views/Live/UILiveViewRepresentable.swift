//
//  UILiveViewRepresentable.swift
//  
//
//  Created by Joseph Hinkle on 4/10/21.
//

import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public protocol UILiveViewRepresentable : LiveUI {
    associatedtype UIViewType : UIView
    func makeUIView(context: Self.Context) -> Self.UIViewType
    func updateUIView(_ uiView: Self.UIViewType, context: Self.Context)
    static func dismantleUIView(_ uiView: Self.UIViewType, coordinator: Self.Coordinator)
    associatedtype Coordinator = Void
    func makeCoordinator() -> Self.Coordinator
    typealias Context = UIViewRepresentableContext<_UIWildcardViewRepresentable<Self>>
    
    // Live App inventions
    associatedtype RegistrationStatus : RegisterWithInterpreter
    static var registerWithInterpreter: Self.RegistrationStatus { get }
}

public protocol RegisterWithInterpreter {}
public struct DoRegisterWithInterpreter: RegisterWithInterpreter {}
public struct DontRegisterWithInterpreter: RegisterWithInterpreter {}

extension UILiveViewRepresentable {
    public var _internal: _InternalLiveUIData {
//        .init(compiledViewGetter: {.init(_UIWildcardViewRepresentable(self))}, protocolName: "UILiveViewRepresentable")
        .init(protocolName: "UILiveViewRepresentable")
    }
    
    public static var Yes: RegisterWithInterpreter {
//        RegisterWithInterpreter(value: true)
        fatalError()
    }
    public static var No: RegisterWithInterpreter {
//        RegisterWithInterpreter(value: false)
        fatalError()
    }
}
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
@available(macOS, unavailable)
public extension UILiveViewRepresentable {
    static func dismantleUIView(_ uiView: Self.UIViewType, coordinator: Self.Coordinator) {
        fatalError()
    }
    var liveBody: Never {
        fatalError()
    }
    func makeCoordinator() -> Self.Coordinator {
        fatalError()
    }
}
