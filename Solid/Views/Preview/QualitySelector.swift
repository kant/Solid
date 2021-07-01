//
//  QualitySelector.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/30/21.
//

import SwiftUI
import RealmSwift
import RealityKit

struct QualitySelector: View {
    
    @ObservedRealmObject var capture: Capture
    @Binding var selectedPreviewQuality: PhotogrammetrySession.Request.Detail?
    
    var body: some View {
        
        HStack {
            ForEach(capture.processedFiles) { file in
                Button {
                    selectedPreviewQuality = file.quality
                } label: {
                    Text(file.quality.name)
                        .padding(8)
                        .background( Color(NSColor.textBackgroundColor) )
                        .cornerRadius(2)
                        .padding([.horizontal], 4)
                }
                .buttonStyle(.plain)

                
            }
        }
        
    }
}

//struct QualitySelector_Previews: PreviewProvider {
//    static var previews: some View {
//        QualitySelector(capture: Capture())
//    }
//}
