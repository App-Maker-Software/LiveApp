//
//  LiveAppBirdView.swift
//  
//
//  Created by Joseph Hinkle on 7/6/21.
//

#if INCLUDE_DEVELOPER_TOOLS
import SwiftUI
#if _BUILD_FROM_SOURCE
import SwiftInterpreterSource
#elseif _BUILD_FOR_APP_MAKER
import SwiftInterpreterPrivate
#else
import SwiftInterpreter
import SwiftInterpreterBinary
#endif

@available(iOS 14.0, *)
struct LiveAppBirdView<Content: View>: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    let baseView: Content
    
    @State private var prevPositionX: CGFloat = .greatestFiniteMagnitude
    @State private var prevPositionY: CGFloat = .greatestFiniteMagnitude
    
    @State private var positionX: CGFloat = .greatestFiniteMagnitude
    @State private var positionY: CGFloat = .greatestFiniteMagnitude
    @State private var isDragging = false
    @State private var startedDragging = false
    
    @State private var askIfHideBird = false
    @State private var hideBird = false
    
    
    private func clipX(_ x: CGFloat, geo: GeometryProxy) -> CGFloat {
        return min(max(x, -geo.size.width*0.5 + 25), geo.size.width*0.5 - 25)
    }
    
    private func clipY(_ y: CGFloat, geo: GeometryProxy) -> CGFloat {
        return min(max(y, -geo.size.height*0.5 + 25), geo.size.height*0.5 - 25)
    }
    
    @ViewBuilder
    private var moreMenu: some View {
        Button {
            
        } label: {
            Label("Auto Hard Reload on Update", systemImage: "circle.dashed.inset.fill")
        }
        Button {
            askIfHideBird = true
        } label: {
            Label("Hide Bird", systemImage: "eye.slash")
        }
    }
    
    @ViewBuilder
    private var menu: some View {
        Button {
            _xcodeBuildAndRun()
        } label: {
            Label("Rebuild with Xcode", systemImage: "hammer.fill")
        }
        Button {
            
        } label: {
            Label("Hard Reload", systemImage: "arrow.clockwise")
        }
        Menu {
            moreMenu
        } label: {
            Label("More", systemImage: "ellipsis")
        }
    }
    
    private var birdBase: some View {
        Menu { menu } label: {
            Image("bird", bundle: Bundle.module)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .opacity(startedDragging ? 0 : 1) // prevents weird rendering bug with content menu
                .opacity(isDragging ? 1 : 0.5)
                .shadow(color: colorScheme == .light ? .black : .gray, radius: 12, x: 0.0, y: 0.0)
        }
    }
    
    private func bird(geo: GeometryProxy) -> some View {
        birdBase
            .offset(x: clipX(positionX, geo: geo), y: clipY(positionY, geo: geo))
            .animation(nil)
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global).onChanged { value in
                if !isDragging {
                    startedDragging = false
                } else {
                    startedDragging = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.startedDragging = false
                    }
                }
                withAnimation(.easeOut(duration: 0.2)) {
                    isDragging = true
                }
                withAnimation(.linear(duration: 0)) {
                    positionX = clipX(clipX(prevPositionX, geo: geo) + value.translation.width, geo: geo)
                    positionY = clipY(clipY(prevPositionY, geo: geo) + value.translation.height, geo: geo)
                }
            }.onEnded { value in
                withAnimation(.easeOut(duration: 0.2)) {
                    isDragging = false
                    if abs(value.predictedEndTranslation.width * value.predictedEndTranslation.height) > 50 {
                        positionX = clipX(clipX(prevPositionX, geo: geo) + value.predictedEndTranslation.width, geo: geo)
                        positionY = clipY(clipY(prevPositionY, geo: geo) + value.predictedEndTranslation.height, geo: geo)
                    }
                }
                prevPositionX = positionX
                prevPositionY = positionY
            })
    }
    
    var body: some View {
        if hideBird {
            baseView.id("_baseView")
        } else {
            GeometryReader { geo in
                baseView.id("_baseView")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(bird(geo: geo))
            }.alert(isPresented: $askIfHideBird) {
                Alert(
                    title: Text("Hide Bird?"),
                    message: Text("To bring the floating bird back, you must completely close your app and relaunch it."),
                    primaryButton: .destructive(Text("Hide")){
                        hideBird = true
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

var hasSetup = false

@available(iOS 14.0, *)
public extension View {
    func setupLiveApp() -> some View {
        if !hasSetup {
            LiveApp.configureHotReloadSession()
            hasSetup = true
        }
        return LiveAppBirdView(baseView: self)
    }
}

#endif
