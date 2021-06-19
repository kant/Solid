//
//  SolidApp.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/18/21.
//

import SwiftUI

@main
struct SolidApp: App {
    
    let storage = Storage()
    
    var body: some Scene {
        WindowGroup {
            ContentView(storage: storage)
        }.windowToolbarStyle( UnifiedWindowToolbarStyle() )
    }
}
