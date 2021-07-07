//
//  LiveAppBirdView.swift
//  
//
//  Created by Joseph Hinkle on 7/6/21.
//

#if INCLUDE_DEVELOPER_TOOLS
import SwiftUI

struct LiveAppBirdView<Content: View>: View {
    
    let baseView: Content
    
    private var bird: some View {
        Image("bird", bundle: Bundle.module)
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
    }
    
    var body: some View {
        baseView.overlay(bird)
    }
}

public extension View {
    func liveAppBird() -> some View {
        LiveAppBirdView(baseView: self)
    }
}

#endif
