//
//  BottomBar.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/27/21.
//

import SwiftUI
import RealmSwift

struct BottomBar: View {
    @EnvironmentObject private var model: ContentViewModel
    @ObservedRealmObject var capture: Capture
    
    
    var body: some View {
        
        if capture.isInPreviewState {
            if let config = model.importConfiguration(for: capture) {
                ImportOptionsView(
                    capture: capture,
                    importConfiguration: config
                )
            } else {
                Text("Could not load ImportConfiguration 1")
            }

        //Share Bar
        } else {
            Button(action: {
                debugPrint("sharing \(capture.name)")
            }, label: {
                Image(systemName: "square.and.arrow.up")
            })
        }
    }
    
}

//struct BottomBar_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomBar()
//    }
//}
