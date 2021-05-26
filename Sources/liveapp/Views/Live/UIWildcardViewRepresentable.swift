//
//  UIWildcardViewRepresentable.swift
//  
//
//  Created by Joseph Hinkle on 4/10/21.
//

import SwiftUI

public struct _UIWildcardViewRepresentable<T: UILiveViewRepresentable>: UIViewRepresentable, View {
    public typealias UIViewType = T.UIViewType
    
    let liveUIView: T
    
    init(_ liveUIView: T) {
        self.liveUIView = liveUIView
    }
    
    public func makeUIView(context: Context) -> UIViewType {
        liveUIView.makeUIView(context: context)
    }
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        liveUIView.updateUIView(uiView, context: context)
    }
}

