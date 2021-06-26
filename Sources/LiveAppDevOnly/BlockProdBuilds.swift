//
//  BlockProdBuilds.swift
//  
//
//  Created by Joseph Hinkle on 6/26/21.
//

/**
 LiveAppDevOnly is for clients who wish to only use LiveApp for development purposes, i.e. fast hot-reloads, but to not want to use it in production builds. By using this LiveAppDevOnly library, we do a compile-time check to ensure that we are not included in any production builds. If it's found that this file is building build in a production configuration, a compile time error is thrown.
 */
#if !DEBUG
#error("LiveAppDevOnly was included in your production build, but you chose to use LiveApp only in development builds. Please manually remove the LiveApp package before distributing. In the future, this process will be automatic, but we first need the Swift Package team to finish support conditional dependencies. https://github.com/apple/swift-evolution/blob/master/proposals/0273-swiftpm-conditional-target-dependencies.md")
#endif
