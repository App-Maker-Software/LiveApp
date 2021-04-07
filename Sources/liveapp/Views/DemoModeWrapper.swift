//
//  DemoModeWrapper.swift
//  LiveApp
//
//  Created by Joseph Hinkle on 4/6/21.
//
#if INCLUDE_DEVELOPER_TOOLS
import SwiftUI

struct DemoModeWrapper: View {
    let subview: AnyView
    @ObservedObject private var demoModalState: DemoModalState = .shared
    var body: some View {
        Group {
            if demoModalState.showDemoModal {
                subview.opacity(0.5).allowsHitTesting(false)
            } else {
                subview
            }
        }.sheet(isPresented: $demoModalState.showDemoModal, onDismiss: {
            UserDefaults.standard.set(true, forKey: "LIVEVIEWDEMO_has_seen")
        }) {
            DemoView(showDemoModal: $demoModalState.showDemoModal)
        }
    }
}
#endif
