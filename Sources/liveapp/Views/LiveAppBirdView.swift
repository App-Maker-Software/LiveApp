//
//  LiveAppBirdView.swift
//  
//
//  Created by Joseph Hinkle on 7/6/21.
//

#if !STUB
#if INCLUDE_DEVELOPER_TOOLS
import SwiftUI
#if _BUILD_FROM_SOURCE
import SwiftInterpreterSource
#elseif _BUILD_FOR_APP_MAKER
import SwiftInterpreterPrivate
#elseif canImport(SwiftInterpreterBinary)
import SwiftInterpreterBinary
#endif

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 14.0, *)
struct LiveAppBirdView<Content: View>: View {
    @Environment (\.colorScheme) var colorScheme: ColorScheme
    
    let baseView: Content
    
    @ObservedObject private var liveAppConfiguration = LiveApp.Configuration.shared
    @ObservedObject private var birdImage = BirdImage.shared
    
    @State private var prevPositionX: CGFloat = .greatestFiniteMagnitude
    @State private var prevPositionY: CGFloat = .greatestFiniteMagnitude
    
    @State private var positionX: CGFloat = .greatestFiniteMagnitude
    @State private var positionY: CGFloat = .greatestFiniteMagnitude
    @State private var isDragging = false
    @State private var startedDragging = false
    
    @State private var askIfHideBird = false
    @State private var hideBird = false
    
    private func clipX(_ x: CGFloat, geo: GeometryProxy) -> CGFloat {
        #if os(macOS)
        return min(max(x, -geo.size.width*0.5 + 25), geo.size.width*0.5 - 25 - 35)
        #else
        return min(max(x, -geo.size.width*0.5 + 25), geo.size.width*0.5 - 25)
        #endif
    }
    
    private func clipY(_ y: CGFloat, geo: GeometryProxy) -> CGFloat {
        return min(max(y, -geo.size.height*0.5 + 25), geo.size.height*0.5 - 25)
    }
    
    @ViewBuilder
    private var moreMenu: some View {
        Button {
            LiveApp.Configuration.shared.autoHardReload.toggle()
            if LiveApp.Configuration.shared.autoHardReload {
                LiveApp.hardReload()
            } else {
                LiveApp.rebuildAllLiveViewStructs()
            }
        } label: {
            SupportLabel("\(LiveApp.Configuration.shared.autoHardReload ? "Soft" : "Hard") Reload on Update", systemImage: "circle.dashed\(LiveApp.Configuration.shared.autoHardReload ? ".inset.fill" : "")")
        }.buttonStyle(PlainButtonStyle()).disabled(!liveAppConfiguration.interpreterIsOn)
        if LiveApp.Configuration.shared.outlineCompiledViewsColor != nil || LiveApp.Configuration.shared.outlineInterpretedViewsColor != nil {
            Button {
                LiveApp.Configuration.shared.showOutlines.toggle()
                LiveApp.rebuildAllLiveViewStructs()
            } label: {
                SupportLabel("\(LiveApp.Configuration.shared.showOutlines ? "Hide" : "Show") Outlines", systemImage: "square\(LiveApp.Configuration.shared.showOutlines ? ".slash" : "")")
            }.buttonStyle(PlainButtonStyle())
        }
        Button {
            askIfHideBird = true
        } label: {
            SupportLabel("Hide Bird", systemImage: "eye.slash")
        }.buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    private var menu: some View {
        Button {
            _xcodeBuildAndRun()
        } label: {
            SupportLabel("Rebuild with Xcode", systemImage: "hammer.fill")
        }.buttonStyle(PlainButtonStyle())
        Button {
            let autoHardReload = LiveApp.Configuration.shared.autoHardReload
            LiveApp.Configuration.shared.autoHardReload = true
            LiveApp.hardReload()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                LiveApp.Configuration.shared.autoHardReload = autoHardReload
            }
        } label: {
            SupportLabel("Hard Reload", systemImage: "arrow.clockwise")
        }.buttonStyle(PlainButtonStyle()).disabled(!liveAppConfiguration.interpreterIsOn)
        Button {
            liveAppConfiguration.interpreterIsOn.toggle()
            LiveApp.rebuildAllLiveViewStructs()
        } label: {
            SupportLabel("Turn \(liveAppConfiguration.interpreterIsOn ? "off" : "on") Interpreter", systemImage: liveAppConfiguration.interpreterIsOn ? "power" : "togglepower")
        }.buttonStyle(PlainButtonStyle())
        SupportMenu {
            moreMenu
        } label: {
            SupportLabel("More", systemImage: "ellipsis")
        }
    }
    
    private var birdBase: some View {
        #if os(macOS)
//        HStack {
            birdImage.getBird()
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .opacity(startedDragging ? 0 : 1) // prevents weird rendering bug with content menu
                .opacity(isDragging ? 1 : 0.5)
                .shadow(color: colorScheme == .light ? .black : .gray, radius: 12, x: 0.0, y: 0.0)
                .overlay(Group {
                    if isDragging {
                        VStack(alignment: positionX < 0 ? .leading : .trailing) {
                            Text("Right click for options").font(.footnote)
                            Text("Drag to move").font(.footnote)
                        }.frame(width: 120)
                        .offset(x: positionX < 0 ? 80 : -80)
                    }
                })
                .contextMenu {
                    menu
                }
//            SupportMenu { menu } label: {
//                Group {
//                    if #available(macOS 11.0, *) {
//                        Image(systemName: "info.circle")
//                    } else {
//                        Text("i")
//                    }
//                }
//            }.frame(width: 35, height: 35)
//        }
        #else
        SupportMenu { menu } label: {
            birdImage.getBird()
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .opacity(startedDragging ? 0 : 1) // prevents weird rendering bug with content menu
                .opacity(isDragging ? 1 : 0.5)
                .shadow(color: colorScheme == .light ? .black : .gray, radius: 12, x: 0.0, y: 0.0)
        }
        #endif
    }
    
    private func bird(geo: GeometryProxy) -> some View {
        #if os(tvOS)
        birdBase
            .offset(x: clipX(positionX, geo: geo), y: clipY(positionY, geo: geo))
            .animation(nil)
        #else
        birdBase
            .offset(x: clipX(positionX, geo: geo), y: clipY(positionY, geo: geo))
            .animation(nil)
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global).onChanged { value in
                if !isDragging {
                    startedDragging = false
                } else {
                    startedDragging = true
                }
                withAnimation(.easeOut(duration: 0.2)) {
                    isDragging = true
                    self.startedDragging = false
                }
                withAnimation(.linear(duration: 0)) {
                    positionX = clipX(clipX(prevPositionX, geo: geo) + value.translation.width, geo: geo)
                    #if os(macOS)
                    positionY = clipY(clipY(prevPositionY, geo: geo) - value.translation.height, geo: geo)
                    #else
                    positionY = clipY(clipY(prevPositionY, geo: geo) + value.translation.height, geo: geo)
                    #endif
                }
            }.onEnded { value in
                withAnimation(.easeOut(duration: 0.2)) {
                    isDragging = false
                    #if !os(macOS)
                    // "throws" the bird
                    if abs(value.predictedEndTranslation.width * value.predictedEndTranslation.height) > 50 {
                        positionX = clipX(clipX(prevPositionX, geo: geo) + value.predictedEndTranslation.width, geo: geo)
                        positionY = clipY(clipY(prevPositionY, geo: geo) + value.predictedEndTranslation.height, geo: geo)
                    }
                    #endif
                }
                prevPositionX = positionX
                prevPositionY = positionY
            })
        #endif
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

@available(iOS 14.0, macOS 10.15, watchOS 6.0, tvOS 14.0, *)
public extension View {
    func setupLiveApp() -> some View {
        if !LiveApp.hasSetup {
            LiveApp.configureHotReloadSession()
        }
        return LiveAppBirdView(baseView: self)
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 14.0, *)
struct SupportMenu<T: View, U: View>: View {
    let content: () -> T
    let label: () -> U
    
    #if !os(tvOS)
    var backupView: some View {
        label().contextMenu(ContextMenu(menuItems: content))
    }
    #endif
    
    var body: some View {
        #if os(tvOS)
        self.contextMenu(menuItems: content)
        #elseif os(watchOS)
        backupView
        #else
        if #available(macOS 11.0, iOS 14.0, *) {
            Menu(content: content, label: label)
                .menuStyle(BorderlessButtonMenuStyle())
        } else {
            backupView
        }
        #endif
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
struct SupportLabel: View {
    let title: String
    let systemImage: String
    
    init(_ title: String, systemImage: String) {
        self.title = title
        self.systemImage = systemImage
    }
    
    var body: some View {
        if #available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *) {
            Label(title, systemImage: systemImage)
        } else {
            HStack {
                #if !os(macOS)
                Image(systemName: systemImage)
                #endif
                Text(title)
            }
        }
    }
}


#if os(macOS)
typealias PlatImage = NSImage
@available(macOS 10.15, *)
extension Image {
    init(platImage: PlatImage) {
        self.init(nsImage: platImage)
    }
}
#else
typealias PlatImage = UIImage
@available(iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Image {
    init(platImage: PlatImage) {
        self.init(uiImage: platImage)
    }
}
#endif


@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
final class BirdImage: ObservableObject {
    static let shared = BirdImage()
    private var bird: Image?
    private var isLoading = false
    private var cacheURL: URL {
        let arrayPaths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheDirectoryPath = arrayPaths[0]
        return cacheDirectoryPath.appendingPathComponent("live_app_bird.png")
    }
    func getBird() -> Image {
        if let bird = bird {
            return bird
        } else if FileManager.default.fileExists(atPath: cacheURL.path),
                  let data = try? Data(contentsOf: cacheURL),
                  let image = PlatImage(data: data) {
            self.bird = Image(platImage: image)
            return getBird()
        }
        if isLoading {
            if #available(macOS 11.0, *) {
                return Image(systemName: "swift")
            } else {
                return Image("")
            }
        }
        isLoading = true
        let birdURL = URL(string: "https://github.com/App-Maker-Software/LiveApp/raw/develop/bird.png")!
        URLSession.shared.dataTask(with: birdURL, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = PlatImage(data: data)
                    else {
                    return
                }
                #if os(iOS)
                self.bird = Image(uiImage: image)
                #else
                self.bird = Image(platImage: image)
                #endif
                try? data.write(to: self.cacheURL)
                self.objectWillChange.send()
                self.isLoading = false
            }
        }).resume()
        if #available(macOS 11.0, *) {
            return Image(systemName: "swift")
        } else {
            return Image("")
        }
    }
}
#endif
#endif
