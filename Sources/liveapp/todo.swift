//
//  todo.swift
//  LiveApp
//
//  Created by Joseph Hinkle on 4/6/21.
//

import Foundation



//
//  Versioning.swift
//
//
//  Created by Joseph Hinkle on 4/2/21.
//


// this defines a live app client version

// there are 3 parts that make up a client version
// 1. cf bundle name converted to a number (build number)
// 2. client iOS version (same build can be running on multiple iOS's)
// 3. client SwiftUIInterpreter version number

// there are 2 things sent to the server to define how the each live view maps to a view
// 1. client version (defined above)
// 2. device id (for A/B testing)

//let CFBundleVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

//
////  Updating.swift
////
////
////  Created by Joseph Hinkle on 3/23/21.
////
//
//import Foundation
//import Combine
////import ExceptionCatcher
//import SwiftASTBuilder
//
//public typealias Update = () -> (String)
//
//extension LiveApp {
//    
//    
//}
