//
//  PreviewView.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import SwiftUI
import QuickLook
import RealityKit

struct PreviewView: View {

    @EnvironmentObject private var model: ContentViewModel
    @ObservedObject var capture: Capture
    
    @State var selectedPreviewQuality: PhotogrammetrySession.Request.Detail = .preview
    
    var body: some View {
        Picker("Preview Quality", selection: $selectedPreviewQuality) {
            ForEach(capture.processedFiles) { file in
                Text(file.qualityName).tag(file.quality)
            }
        }
        .pickerStyle(.inline)
        
        ViewportView(selectedPreviewQuality: $selectedPreviewQuality)
        
        if capture.isInPreviewState {
            ImportOptionsView(capture: capture)
        }
        
    }
}

struct PreviewView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView( capture: Capture(), selectedPreviewQuality: .preview )   //.constant( )
    }
}


