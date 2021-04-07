//
//  Network.swift
//  
//
//  Created by Joseph Hinkle on 4/7/21.
//

import Foundation
import Combine
import FlattenedSwiftUIInterpreter

public final class Network {
    private static var anyCancellables: [AnyCancellable] = []
    private static let liveFileDownloadProcessingQueue = DispatchQueue(label: "live-file-download")
    public static func fetchAllViews(for liveAppId: String) {
        let url = URL(string: "https://api.liveapp.cc/v1/liveapps/\(liveAppId)/views/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        do {
            let parameters = makeClientVersionJSON()
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            return
        }
        anyCancellables.append(URLSession.shared.dataTaskPublisher(for: request).map { info -> Data in
            return info.data
        }
        .replaceError(with: nil)
        .subscribe(on: Self.liveFileDownloadProcessingQueue)
        .sink { data in
            let decoder = JSONDecoder()
            if let data = data {
                if let allViews = try? decoder.decode(AllViewsJSON.self, from: data) {
                    for view in allViews.views {
                        fetch(liveViewId: view.id, liveViewName: view.name, for: liveAppId)
                    }
                }
            }
        })
    }
    public static func fetch(liveViewId: String, liveViewName: String, for liveAppId: String) {
        let url = URL(string: "https://data.liveapp.cc/\(liveAppId)/views/\(liveViewId)")!
        anyCancellables.append(URLSession.shared.dataTaskPublisher(for: url).map { info -> Data in
            return info.data
        }
        .replaceError(with: nil)
        .subscribe(on: Self.liveFileDownloadProcessingQueue)
        .sink { data in
            if let data = data {
                try? update_struct_liveview_data(
                    name: liveViewName,
                    liveAppId: liveAppId,
                    liveViewData: data
                )
            }
        })
    }
}
