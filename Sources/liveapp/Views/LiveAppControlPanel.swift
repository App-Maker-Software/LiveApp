//
//  LiveAppControlPanel.swift
//  LiveApp
//
//  Created by Joseph Hinkle on 4/6/21.
//

#if INCLUDE_DEVELOPER_TOOLS
import SwiftUI

//
// Public API access to control panel.
//
extension LiveApp {
    /// Opens the Live App control panel allowing for the client to start a live development session. You must have the `liveAppControlPanelSheet()` modifier placed within your SwiftUI view hierarchy for it to work. See `https://docs.liveapp.cc` for more information.. Only available if the `INCLUDE_DEVELOPER_TOOLS` compiler flag is present.
    public static func launchControlPanel() {
        ShowLiveAppControlPanel.shared.showPanel = true
    }
}

extension View {
    /// Location for the Live App control panel to spawn. See `LiveApp.launchControlPanel()` for more information.. Only available if the `INCLUDE_DEVELOPER_TOOLS` compiler flag is present.
    public func liveAppControlPanelSheet() -> some View {
        LiveAppControlPanel(content: self)
    }
}

//
// Private control panel implementation.
//

/// A view which only can be shown when the `INCLUDE_DEVELOPER_TOOLS` compiler flag is present.
fileprivate struct LiveAppControlPanel<Content: View>: View {
    
    @ObservedObject fileprivate var showLiveAppControlPanel: ShowLiveAppControlPanel = .shared
    fileprivate let content: Content
    
    fileprivate var body: some View {
        content.sheet(isPresented: $showLiveAppControlPanel.showPanel) {
            Text("LiveAppControlPanel")
        }
    }
}

fileprivate final class ShowLiveAppControlPanel: ObservableObject {
    @Published fileprivate var showPanel = false
    fileprivate static let shared = ShowLiveAppControlPanel()
}
#endif
