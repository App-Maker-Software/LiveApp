//
//  BlockProdBuilds.swift
//  
//
//  Created by Joseph Hinkle on 6/26/21.
//

/**
 SwiftUIHotReload is for clients who wish to only use LiveApp for development purposes, i.e. fast hot-reloads, but to not want to use it in production builds. By using this SwiftUIHotReload library, we do a compile-time check to ensure that we are not included in any production builds. If it's found that this file is building build in a production configuration, a compile time error is thrown.
 */
#if !DEBUG
#error("SwiftUIHotReload was included in your production build. Please manually remove the package before distributing. In the future, this process will be automatic, but we first need the Swift Package team to finish support conditional dependencies. https://github.com/apple/swift-evolution/blob/master/proposals/0273-swiftpm-conditional-target-dependencies.md")
#endif
