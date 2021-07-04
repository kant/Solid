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
    
    @ObservedObject var model: ContentViewModel
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
            ZStack() {
                ViewportView(viewportModel: model.viewportModel, capture: capture, selectedPreviewQuality: $selectedPreviewQuality)
                
                VStack {
                    //Preview Quality Picker
                    ToolBar(model: model, capture: capture, selectedPreviewQuality: $selectedPreviewQuality)
                        //.colorScheme(.light)
                        .padding()
                    
                    Spacer()
                    
                    //Processing Bar
                    if capture.state == .processing {
                        ProgressBar(model: model, capture: capture)
                            .padding()
                            .background( Color(NSColor.textBackgroundColor) )
                            .cornerRadius(10)
                            .padding()
                    }
                }
            }
        }
    }
}

//struct PreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        let previewContent = PreviewContent()
//        PreviewView(model: previewContent.contentViewModel, capture: PreviewContent.capture)
//    }
//}


