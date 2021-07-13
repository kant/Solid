//
//  ViewportView.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/20/21.
//

import SwiftUI
import SceneKit
import RealityKit
import RealmSwift

struct ViewportView: View { //Equatable
    
    @ObservedObject var model: ContentViewModel
    @ObservedObject var viewportModel: ViewportModel
    @ObservedRealmObject var capture: Capture
    
    @Binding var selectedPreviewQuality: PhotogrammetrySession.Request.Detail
    
    var body: some View {
        ZStack {
            SceneViewRepresentable(
                viewportModel: viewportModel,
                capture: capture,
                selectedPreviewQuality: selectedPreviewQuality
            )
            
            VStack {
                
                //Processing Bar
                if capture.state == .processing {
                    ProgressBar(model: model, capture: capture)
                        .padding()
                        .background( Color(NSColor.textBackgroundColor) )
                        .cornerRadius(10)
                        .padding()
                }
                
                Spacer()
                
                //Preview Quality Picker
                HStack {
                    Spacer()
                    ToolBar(model: model, capture: capture, selectedPreviewQuality: $selectedPreviewQuality)
                        .padding(8)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                        .padding(16)
                    Spacer()
                }
            }
            
        }
    }
}

