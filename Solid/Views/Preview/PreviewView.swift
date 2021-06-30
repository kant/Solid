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
    
    @ObservedObject var model: ContentViewModel
    @ObservedRealmObject var capture: Capture
    
    @State var selectedPreviewQuality: PhotogrammetrySession.Request.Detail = .preview
    
    var body: some View {
        
        if capture.isInPreviewState {
            
            if let config = model.importConfiguration(for: capture) {
                ConfigurationView(model: model, capture: capture, importConfiguration: config)
            } else {
                Text("Could not load ImportConfiguration 1")
            }
            
        } else {
            ZStack() {
                ViewportView(model: model, capture: capture, selectedPreviewQuality: selectedPreviewQuality)
                
                VStack {
                    //Preview Quality Picker
                    Picker("Preview Quality", selection: $selectedPreviewQuality) {
                        ForEach(capture.processedFiles) { file in
                            Text(file.quality.name).tag(file.quality)
                        }
                    }
                    .pickerStyle(.inline)
                    
                    Spacer()
                    
                    //Bottom Bar
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

//struct PreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        PreviewView( capture: Capture(), selectedPreviewQuality: .preview )   //.constant( )
//    }
//}


