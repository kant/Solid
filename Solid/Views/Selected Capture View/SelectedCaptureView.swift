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

struct SelectedCaptureView: View {
    
    @ObservedObject var model: MainViewModel
    @ObservedRealmObject var capture: Capture
    
    @State var selectedPreviewQuality: PhotogrammetrySession.Request.Detail = .preview
    
    var body: some View {
        switch capture.state {
        case .configuring:
            if let config = model.importConfiguration(for: capture) {
                ConfigurationView(model: model, capture: capture, importConfiguration: config)
            } else {
                Text("Could not load ImportConfiguration 1")
            }
            
        case .processing, .stored:
            ViewportView(model: model, viewportModel: model.viewportModel, capture: capture, selectedPreviewQuality: $selectedPreviewQuality)
        }
    }
}


