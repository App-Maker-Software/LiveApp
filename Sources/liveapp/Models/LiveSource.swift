//
//  LiveSource.swift
//  LiveApp
//
//  Created by Joseph Hinkle on 4/6/21.
//

import Foundation

public enum LiveSource {
    case none, remoteRepository(liveViewName: String), custom(() -> (Data))
}

