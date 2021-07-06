//
//  BottomBar.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/27/21.
//

import SwiftUI
import RealmSwift

struct ProgressBar: View {
    @ObservedObject var model: ContentViewModel
    @ObservedRealmObject var capture: Capture
    
    var body: some View {
        let progress = ((model.currentlyProcessingProgress ?? 0) * 100)
        let progressRounded = String(format: "%.2f", progress)
        HStack {
            ProgressView(
                "Processing: ",
                value: progress,
                total: 100
            )
            Text("\(progressRounded)%")
                .font(.headline)
            
//            Button {
//                model.storage.new(ProcessedFile(quality: .preview), for: capture)
//            } label: {
//                Text("hi")
//            }
        }
    }
}

//struct BottomBar_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomBar()
//    }
//}
