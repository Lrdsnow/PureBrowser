//
//  ContentView.swift
//  PureBrowser Watch App
//
//  Created by Lrdsnow on 4/8/24.
//

import SwiftUI

@main
struct PureBrowser_App: App {
    var body: some Scene {
        WindowGroup {
            FileBrowserView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct FileBrowserView: View {
    @State private var currentDirectory: URL? = URL(fileURLWithPath: "/")
    @State private var selectedFile: URL?
    
    var body: some View {
        NavigationView {
            List {
                if let currentDirectory = currentDirectory, currentDirectory != URL(fileURLWithPath: "/") {
                    Button(action: {
                        let parentDirectory = currentDirectory.deletingLastPathComponent()
                        self.currentDirectory = parentDirectory
                    }, label: {
                        HStack {
                            Text("Parent Directory")
                        }
                    })
                }
                
                ForEach(contentsOfCurrentDirectory(), id: \.self) { item in
                    if item.isDirectory {
                        Button(action: {self.currentDirectory = item.url}, label: {
                            HStack {
                                Image(systemName: "folder")
                                Text(item.name)
                            }
                        })
                    } else {
                        Button(action: {self.selectedFile = item.url}, label: {
                            HStack {
                                Image(systemName: "doc")
                                Text(item.name)
                            }
                        })
                    }
                }
            }
            .navigationTitle(currentDirectory?.lastPathComponent ?? "File Browser")
        }
    }
    
    func contentsOfCurrentDirectory() -> [FileItem] {
        guard let directoryURL = currentDirectory else { return [] }
        
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            return contents.map { url in
                FileItem(url: url)
            }
        } catch {
            print("Error listing contents of directory: \(error.localizedDescription)")
            return []
        }
    }
}

struct FileItem: Hashable {
    let url: URL
    
    var name: String {
        return url.lastPathComponent
    }
    
    var isDirectory: Bool {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
}
