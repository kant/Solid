//
//  SolidApp.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/18/21.
//

import SwiftUI

@main
struct SolidApp: App {
    @StateObject var model = Model(storage: Storage())
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
        .windowToolbarStyle( UnifiedWindowToolbarStyle() )
    }
}
