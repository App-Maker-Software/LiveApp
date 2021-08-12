//
//  main.swift
//  
//
//  Created by Joseph Hinkle on 8/12/21.
//

import Foundation

// the LiveAppCLIInstaller's only job is to download the actualy live app cli and then pipe the arguments to it once/if it's downloaded
// the first 2 arguments will be the only one the installer uses, and it drops it when passing it to the real liveapp cli
// the first 2 arguments is just the version number it's going to use

@discardableResult
func shell(_ args: [String]) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}
func download(v: String, saveTo liveAppCliZipPath: URL, destURL: URL) -> Bool {
    print("Downloading LiveAppCli version \(v)...")
    let name = "cli\(v)"
    let extractPath = "./" + name
    func postProccess() -> Bool {
        func moveFolder() -> Bool {
            do {
                print("moving item")
                try FileManager.default.moveItem(atPath: extractPath, toPath: destURL.path)
                return true
            } catch {
                print(error.localizedDescription)
                exit(1)
            }
        }
        print(extractPath)
        if FileManager.default.fileExists(atPath: extractPath) {
            return moveFolder()
        }
        print("unzipping")
        if shell(["unzip", liveAppCliZipPath.path]) == 0 {
            return moveFolder()
        } else {
            return false
        }
    }
    if FileManager.default.fileExists(atPath: liveAppCliZipPath.path) {
        return postProccess()
    }
    do {
        switch v {
        case "0.4":
            let url = URL(string: "https://github.com/App-Maker-Software/LiveApp/releases/download/0.4.0/cli0.4.zip")!
            let (data, _, error) = URLSession.shared.syncRequest(with: url)
            if let data = data {
                try data.write(to: liveAppCliZipPath)
                return postProccess()
            }
            print(error?.localizedDescription ?? "Unknown error")
            return false
        default:
            print("No known version \(v)")
            exit(1)
        }
    } catch {
        print(error.localizedDescription)
        exit(1)
    }
}
let args = CommandLine.arguments
if args.count >= 3 && args[1] == "-v" {
    let v = args[2]
    let argsToLiveApp = args.dropFirst(3)
    let liveAppCliFolderPath: String = "\(URL(fileURLWithPath: args[0]).deletingLastPathComponent().path)/cli\(v)"
    let liveAppCliPath: String = "\(URL(fileURLWithPath: args[0]).deletingLastPathComponent().path)/cli\(v)/liveapp"
    let liveAppCliZipPath: String = "\(URL(fileURLWithPath: args[0]).deletingLastPathComponent().path)/cli\(v).zip"
    func downloadOrRun() {
        func run() {
            var shellArgs: [String] = [liveAppCliPath]
            shellArgs.append(contentsOf: argsToLiveApp)
            exit(shell(shellArgs))
        }
        if FileManager.default.fileExists(atPath: liveAppCliPath) {
            run()
        } else {
            if download(v: v, saveTo: URL(fileURLWithPath: liveAppCliZipPath), destURL: URL(fileURLWithPath: liveAppCliFolderPath)) {
                run()
            } else {
                exit(1)
            }
        }
    }
    downloadOrRun()
} else {
    print("Usage: liveappi -v <cli_version_number> [cli_arguments]")
    exit(0)
}


extension URLSession {
    
    func syncRequest(with url: URL) -> (Data?, URLResponse?, Error?) {
       var data: Data?
       var response: URLResponse?
       var error: Error?
       
       let dispatchGroup = DispatchGroup()
       let task = dataTask(with: url) {
          data = $0
          response = $1
          error = $2
          dispatchGroup.leave()
       }
       dispatchGroup.enter()
       task.resume()
       dispatchGroup.wait()
       
       return (data, response, error)
    }
    
    func syncRequest(with request: URLRequest) -> (Data?, URLResponse?, Error?) {
       var data: Data?
       var response: URLResponse?
       var error: Error?
       
       let dispatchGroup = DispatchGroup()
       let task = dataTask(with: request) {
          data = $0
          response = $1
          error = $2
          dispatchGroup.leave()
       }
       dispatchGroup.enter()
       task.resume()
       dispatchGroup.wait()
       
       return (data, response, error)
    }
    
 }
