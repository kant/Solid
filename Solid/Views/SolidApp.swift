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
    
    var body: some Scene {
        WindowGroup {
            MainView(model: model)
        }
        .windowToolbarStyle( UnifiedWindowToolbarStyle() )
    }
}
