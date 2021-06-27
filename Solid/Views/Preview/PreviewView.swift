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
    @ObservedRealmObject var capture: Capture
    
    @State var selectedPreviewQuality: PhotogrammetrySession.Request.Detail = .preview
    
    var body: some View {
        ZStack() {
            ViewportView(selectedPreviewQuality: $selectedPreviewQuality)
            
            VStack {
                //Preview Quality Picker
                Picker("Preview Quality", selection: $selectedPreviewQuality) {
                    ForEach(capture.processedFiles) { file in
                        Text(file.qualityName).tag(file.quality)
                    }
                }
                .pickerStyle(.inline)
                
                Spacer()
                
                //Import Config Bar
                BottomBar(capture: capture)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding()
                    
            }
        }

        
        
    }
}

struct PreviewView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView( capture: Capture(), selectedPreviewQuality: .preview )   //.constant( )
    }
}


