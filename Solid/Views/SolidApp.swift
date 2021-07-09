//
//  SolidApp.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/18/21.
//

import SwiftUI
import RealmSwift

@main
struct SolidApp: SwiftUI.App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var model: ContentViewModel = {
        let realm = try! Realm()
        let storage = Storage(with: realm)
        return ContentViewModel(storage: storage)
    }()
    
    var body: some Scene {
        WindowGroup {
            MainView(model: model)
        }
        
        
        .commands {
            CommandGroup(replacing: .newItem) {
                EmptyView()
            }
            CommandGroup(replacing: .help) {
                EmptyView()
            }
            
            
            CommandGroup(replacing: .appInfo) {
                if let contributeUrl = URL(string: "https://github.com/aswyer/Solid") {
                    Link("Solid Open-Source Project", destination: contributeUrl)
                }
                
                Divider()
                
                if
                    let gsgUrl = URL(string: "https://greyscalegorilla.com"),
                    let hdriHavenUrl = URL(string: "https://hdrihaven.com")
                {
                    Text("Environments from:")
                    Link("Greyscalegorilla", destination: gsgUrl)
                    Link("HDRIHaven", destination: hdriHavenUrl)
                }
            }
            SidebarCommands()
        }
        .windowToolbarStyle( UnifiedWindowToolbarStyle() )
        
    }
}


class AppDelegate: NSObject, NSApplicationDelegate {
    
    //var model: ContentViewModel?
    @ObservedResults(Capture.self, sortDescriptor: SortDescriptor(keyPath: "dateCreated", ascending: false)) var captures
    
    func applicationWillTerminate(_ notification: Notification) {
        //guard let model = model else { return }
        debugPrint("applicationWillTerminate")
        
        let realm = try! Realm()
        let storage = Storage(with: realm)
        
        var capturesToDelete: [Capture] = []
        
        for capture in captures {
            if capture.state != .stored {
                capturesToDelete.append(capture)
            }
        }
        
        storage.delete(captures: capturesToDelete)
    }
}
