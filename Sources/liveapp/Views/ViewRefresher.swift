//
//  ViewRefresher.swift
//  
//
//  Created by Joseph Hinkle on 7/7/21.
//

#if !STUB
import SwiftUI

@available(macOS 10.15, watchOS 6.0, tvOS 13.0, iOS 13.0, *)
final class _ViewRefresher: ObservableObject {
    static let shared: _ViewRefresher = .init()
}

@available(macOS 10.15, watchOS 6.0, tvOS 13.0, iOS 13.0, *)
struct RefreshableView<Body: View>: View {
    
    @ObservedObject private var _viewRefresher: _ViewRefresher = .shared
    
    let buildBody: () -> Body
    
    var body: some View {
        buildBody()
    }
}
#endif
