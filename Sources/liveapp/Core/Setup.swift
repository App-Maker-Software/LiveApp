//
//  LiveApp.swift
//  LiveApp
//
//  Created by Joseph Hinkle on 4/6/21.
//

import Foundation
import FlattenedSwiftUIInterpreter

/// API for talking with the Live App Swift Package
public final class LiveApp {
    /// This function configures LiveApp for self-hosted solutions. While in this mode, Live App will never contact the `liveapp.cc` webserver. Network requests will be limited to the `remoteRepository` URL provided in this configuration. Go to https://liveapp.cc/sales to purchase an enterprise license key or pass "demo" to try for free. `liveViews` property should be autogenerated from the LiveApp helper commandline tool. See https://docs.liveapp.cc for more information.
    ///
    /// ```
    /// LiveApp.configureEnterpriseMode(
    ///     licenseKey: "demo",
    ///     remoteRepository: .SelfHosted(baseURL: "https://example.com/"),
    ///     )
    /// ```
    ///
    /// - Parameter licenseKey: Enterprise license key. Pass `"demo"` to demo self-hosting.
    /// - Parameter remoteRepository: URL to download self-hosted live views. Pass `.LiveAppCC` to continue using the service provided by liveapp.cc.
    public static func configureSelfHosted(
        licenseKey: String,
        remoteRepository: RemoteRepositoryOption
    ) {
        guard let liveAppBundleUrl = Bundle.main.url(forResource: "LiveApp", withExtension: "bundle"), let liveAppBundle = Bundle(url: liveAppBundleUrl) else {
            #if INCLUDE_DEVELOPER_LOGGING
            print("Missing LiveApp.bundle in target. See \(liveAppDocsLink) for more information.")
            #endif
            return
        }
        #if INCLUDE_DEVELOPER_TOOLS
        do {
            try FlattenedSwiftUIInterpreter.unlock_for_self_hosting(licenseKey: licenseKey, liveAppBundle: liveAppBundle)
            return
        } catch let error as FlattenedSwiftUIInterpreter.ConfigureError {
            handleConfigureError(error: error)
        } catch {
            handleConfigureError(error: nil)
        }
        #else
        try? FlattenedSwiftUIInterpreter.unlock_for_self_hosting(licenseKey: licenseKey, liveAppBundle: liveAppBundle)
        #endif
    }
    /// This function configures LiveApp for use via the `liveapp.cc` backend. While in this mode, Live App will contact the `liveapp.cc` webserver to manage live views. Go to https://liveapp.cc/ on an iOS device and open the App Clip to manage your live app instances.  A`LiveApp.bundle` should be in added to your project target. This bundle can be autogenerated from the LiveApp helper commandline tool. See https://docs.liveapp.cc for more information.
    ///
    /// ```
    /// LiveApp.configure(apiKey: "YYYYYYYY-ZZZZ")
    /// ```
    ///
    /// - Parameter apiKey: API key for your live app. Go to `https://liveapp.cc/home` to get your API key.
    public static func configure(apiKey: String) {
        guard let liveAppBundleUrl = Bundle.main.url(forResource: "LiveApp", withExtension: "bundle"), let liveAppBundle = Bundle(url: liveAppBundleUrl) else {
            #if INCLUDE_DEVELOPER_LOGGING
            print("Missing LiveApp.bundle in target. See \(liveAppDocsLink) for more information.")
            #endif
            return
        }
        #if INCLUDE_DEVELOPER_TOOLS
        do {
            try FlattenedSwiftUIInterpreter.unlock_for_live_app_server(apiKey: apiKey, liveAppBundle: liveAppBundle)
            return
        } catch let error as FlattenedSwiftUIInterpreter.ConfigureError {
            handleConfigureError(error: error)
        } catch {
            handleConfigureError(error: nil)
        }
        #else
        try? FlattenedSwiftUIInterpreter.unlock_for_live_all_server(apiKey: apiKey, liveAppBundle: liveAppBundle)
        #endif
    }
    
    #if INCLUDE_DEVELOPER_TOOLS
    private static func handleConfigureError(error: FlattenedSwiftUIInterpreter.ConfigureError?) {
        switch error {
        case .badApiKeyFormat:
            #if PRODUCTION
            print("LiveApp.configure(...) failed. API Token must be in the format YYYYYYYY-ZZZZ.")
            #else
            fatalError("LiveApp.configure(...) failed. API Token must be in the format YYYYYYYY-ZZZZ. Note: Malformed setup calls will NEVER crash the app built for production.")
            #endif
        case .wrongBundle:
            #if PRODUCTION
            print("LiveApp.configure(...) failed. API Token is for another app Bundle ID. Go to https://liveapp.cc/home to generate a new API key.")
            #else
            fatalError("LiveApp.configure(...) failed. API Token is for another app Bundle ID. Go to https://liveapp.cc/home to generate a new API key. Note: Malformed setup calls will NEVER crash the app built for production.")
            #endif
        case .badLicense:
            #if PRODUCTION
            print("LiveApp.configure(...) failed. The given license key is invalid.")
            #else
            fatalError("LiveApp.configure(...) failed. The given license key is invalid. Note: Malformed setup calls will NEVER crash the app built for production.")
            #endif
        default:
            break
        }
        #if PRODUCTION
        print("LiveApp.configure(...) failed. Unknown error.")
        #else
        fatalError("LiveApp.configure(...) failed. Unknown error. Note: Malformed setup calls will NEVER crash the app built for production.")
        #endif
    }
    #endif
}