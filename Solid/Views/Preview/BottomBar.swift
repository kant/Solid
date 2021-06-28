//
//  BottomBar.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/27/21.
//

import SwiftUI
import RealmSwift

struct BottomBar: View {
    @ObservedObject var model: ContentViewModel
    @ObservedRealmObject var capture: Capture
    
    var body: some View {
        
        //Config Bar
        if capture.isInPreviewState {
            if let config = model.importConfiguration(for: capture) {
                ImportOptionsView(
                    model: model,
                    capture: capture,
                    importConfiguration: config
                )
            } else {
                Text("Could not load ImportConfiguration 1")
            }

        //Progress Bar
        } else { //if let progress = model.currentlyProcessingProgress
            let progress = (model.currentlyProcessingProgress ?? 0) * 100
            HStack {
                ProgressView(
                    "Processing: ",
                    value: progress,
                    total: 100
                )
                Text("\( progress ) %")
                    .font(.headline)
            }
        }
    }
    
}

//struct BottomBar_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomBar()
//    }
//}
