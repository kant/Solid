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


