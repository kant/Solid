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
    
    @StateObject var model: ContentViewModel = {
        let realm = try! Realm()
        let storage = Storage(with: realm)
        return ContentViewModel(storage: storage)
    }()
    
    @State var displayHelpWindow = false
    
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
                    Link("Contribute to Solid", destination: contributeUrl)
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
        
        
        WindowGroup("HelpWindowGroup") {
            Text("HELP window")
                .padding()
                .handlesExternalEvents(
                    preferring: Set(arrayLiteral: "HelpWindowGroup"),
                    allowing: Set(arrayLiteral: "*")
                )
        }
        .handlesExternalEvents(matching: Set(arrayLiteral: "HelpWindowGroup"))
        //.windowToolbarStyle( UnifiedWindowToolbarStyle() )
        
    }
}
