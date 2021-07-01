//
//  File.swift
//  
//
//  Created by Joseph Hinkle on 4/6/21.
//
/*
#if INCLUDE_DEVELOPER_TOOLS
import SwiftUI

struct DemoView: View {
    @Binding var showDemoModal: Bool
    var navBody: some View {
        VStack {
            Button(action: {
                if let url = URL(string: "https://liveapp.cc/sales/") {
                    #if os(macOS)
                    NSWorkspace.shared.open(url)
                    #elseif os(watchOS)
                    // no way to open link on the watch
                    #else
                    UIApplication.shared.open(url)
                    #endif
                }
            }, label: {
                (Text("You are using a demo version of Live App's SwiftUI Interpreter. You can purchase the full version at ") + Text("https://liveapp.cc/sales/").foregroundColor(.blue))
            }).buttonStyle(PlainButtonStyle())
        }
    }
    @ViewBuilder
    var navContents: some View {
        #if os(macOS) || os(watchOS)
        VStack {
            Text("Live App Demo").font(.title)
            navBody
            Button("Close") {
                showDemoModal = false
            }
        }
        #else
        navBody
            .navigationBarTitle("Live App Demo")
            .navigationBarItems(trailing: Button("Close") {
                showDemoModal = false
            })
        #endif
    }
    @ViewBuilder
    var bodyPart2: some View {
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
    var body: some View {
        if #available(iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
            NavigationView {
                navContents
            }
        } else {
            bodyPart2
        }
    }
}
#endif
*/
