//
//  NotSetupView.swift
//  LiveApp
//
//  Created by Joseph Hinkle on 4/6/21.
//
/*
#if INCLUDE_DEVELOPER_TOOLS
import SwiftUI

struct NotSetupView: View {
    @State private var showModal = true
    var navBody: some View {
        VStack(spacing: 15) {
            Spacer()
            Text("Live App is not properly setup! All Live Views are defaulting to the compiled bodies and not using the interpreter.")
            Text("To learn more, visit our website linked below for documentation.")
            HStack {
                Button("Later") {
                    showModal = false
                }
                Button(liveAppDocsLink) {
                    if let url = URL(string: liveAppDocsLink) {
                        #if os(macOS)
                        NSWorkspace.shared.open(url)
                        #elseif os(watchOS)
                        // cannot open link on watchesnavContents
                        #else
                        UIApplication.shared.open(url)
                        #endif
                    }
                }
            }
            Spacer()
            (Text("Setup modals like this will ") + Text("never").bold() + Text(" appear in production/release builds.")).font(.footnote)
        }
    }
    @ViewBuilder
    var navContents: some View {
        #if os(macOS) || os(watchOS)
        VStack {
            Text("Live App not Setup").font(.title)
            navBody
        }
        #else
        navBody.navigationBarTitle("Live App not Setup")
        #endif
    }
    @ViewBuilder
    var detailsPart2: some View {
        #if os(watchOS)
        if #available(watchOS 7.0, *) {
            NavigationView {
                navContents
            }
        } else {
            navContents
        }
        #else
        NavigationView {
            navContents
        }
        #endif
    }
    @ViewBuilder
    var details: some View {
        if #available(iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
            NavigationView {
                navContents
            }
        } else {
            detailsPart2
        }
    }
    var body: some View {
        EmptyView().sheet(isPresented: $showModal) {
            details
        }
    }
}
#endif
*/
