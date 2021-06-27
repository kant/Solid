//
//  PreviewView.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import SwiftUI
import QuickLook
import RealityKit
import RealmSwift

struct PreviewView: View {
    
    @EnvironmentObject private var model: ContentViewModel
    @StateRealmObject var capture: Capture
    
    @State var selectedPreviewQuality: PhotogrammetrySession.Request.Detail = .preview
    
    var body: some View {
        ViewportView(selectedPreviewQuality: $selectedPreviewQuality).overlay {
            Picker("Preview Quality", selection: $selectedPreviewQuality) {
                ForEach(capture.processedFiles) { file in
                    Text(file.qualityName).tag(file.quality)
                }
            }
            .pickerStyle(.inline)
            Spacer()
        }

        if capture.isInPreviewState, let config = model.importConfiguration(for: capture) {
            ImportOptionsView(  
                capture: capture,
                importConfiguration: config
            )
        } else {
            Text("Could not load ImportConfiguration 1")
        }
        
    }
}

struct PreviewView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView( capture: Capture(), selectedPreviewQuality: .preview )   //.constant( )
    }
}


