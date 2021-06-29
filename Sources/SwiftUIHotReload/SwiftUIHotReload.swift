//
//  SwiftUIHotReload.swift
//  
//
//  Created by Joseph Hinkle on 6/28/21.
//

import Foundation
import Core
import Client
import LiveApp
//#if _BUILD_FROM_SOURCE
import SwiftInterpreterSource
//#else
//import FlattenedSwiftUIInterpreter
//#endif


let liveAppDocsLink = "https://docs.liveapp.cc"

private var sendAction: ((ActionBuilder) throws -> Void)? = nil

public final class SwiftUIHotReload {
    public static func connectToHotReloadServer() {
        guard let liveAppBundleUrl = Bundle.main.url(forResource: "LiveApp", withExtension: "bundle"), let liveAppBundle = Bundle(url: liveAppBundleUrl) else {
            print("Missing LiveApp.bundle in target. See \(liveAppDocsLink) for more information.")
            return
        }
        if let filepath = liveAppBundle.path(forResource: "hotreloadinfo", ofType: "json") {
            do {
                let contents = try Data(contentsOf: URL(fileURLWithPath: filepath))
                let decoder = JSONDecoder()
                let hotReloadInfo = try decoder.decode(HotReloadInfo.self, from: contents)
                do {
                    try connectClient(to: hotReloadInfo.ip, on: .global(), sendAction: &sendAction, recieveAction: {_,_ in})
                    Core.onSyncFiles { recievedSyncFiles in
                        print("got something!")
                        for file in recievedSyncFiles.files {
                            print("\(file.relativePath) and size is \(file.contents.count)")
                            if file.relativePath.fileExtension == "view" {
                                // update the live view which the same struct name as this view
                                do {
                                    try SwiftInterpreterSource.update_struct_liveview_data(
                                        name: file.relativePath.replacingOccurrences(of: ".view", with: ""),
                                        liveAppId: "",
                                        liveViewData: file.contents
                                    )
                                } catch {
                                    fatalError()
                                }
                            }
                        }
                    }
                } catch {
                    print("could not connect to hot reload server at \(hotReloadInfo.ip)")
                }
            } catch {
                print("hotreloadinfo.json contents could not be loaded!")
            }
        } else {
            print("hotreloadinfo.json not found!")
        }
    }
}


extension String {
    var fileExtension: String? {
        if let ext = self.components(separatedBy: ".").last {
            return ext
        }
        return nil
    }
}
