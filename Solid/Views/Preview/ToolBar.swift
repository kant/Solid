//
//  QualitySelector.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/30/21.
//

import SwiftUI
import RealmSwift
import RealityKit

struct ToolBar: View {
    
    @ObservedObject var model: ContentViewModel
    @ObservedRealmObject var capture: Capture
    
    @State var showLightingPopover = false
    
    @AppStorage("wantsDOF") var wantsDOF = Defaults.wantsDOF
    @AppStorage("focusDistance") var focusDistance = Defaults.focusDistance
    @AppStorage("enviromentRotation") var enviromentRotation = Defaults.enviromentRotation
    @AppStorage("enviromentBrightness") var enviromentBrightness = Defaults.enviromentBrightness
    
    @Binding var selectedPreviewQuality: PhotogrammetrySession.Request.Detail
    
    var body: some View {
        
        HStack {
            //Reset Frame
            Button {
                model.viewportModel.resetFrame()
            } label: {
                Image(systemName: "camera.metering.spot") //camera.viewfinder
                    .font(.body.weight(.bold))
            }
            
            //Rotate Around
//            Button {
//                model.viewportModel.toggleRotate()
//            } label: {
//                Image(systemName: "play.fill") //camera.viewfinder
//                    .font(.body.weight(.bold))
//            }
        
            //Lighting Controls
            Button {
                showLightingPopover = true
            } label: {
                Image(systemName: "rotate.3d")
                    .font(.body.weight(.bold))
            }
            .popover(isPresented: $showLightingPopover) {
                VStack {
                    Text("Enviroment")
                        .font(.headline)
                    
                    Text("Lighting Image Choices")
                        .padding()
                    
                    VStack {
                        Slider(value: $enviromentRotation, in: 0...1, label: {
                            Text("Rotate:")
                        })
                        
                        Slider(value: $enviromentBrightness, in: 0...1, label: {
                            Text("Brightness:")
                        })
                    }
                        .padding()
                    
                    Divider()
                    
                    Toggle("Depth of Field", isOn: $wantsDOF)
                    
                    if wantsDOF {
                        Slider(value: $focusDistance, in: Defaults.minFocusDistance...Defaults.maxFocusDistance, label: {
                            Text("Focus Distance:")
                        })
                    }
                }
                .padding()
            }
            
            //Quality Picker
            Picker(selection: $selectedPreviewQuality, label: EmptyView()) {
                ForEach(capture.processedFiles) { file in
                    Text(file.quality.name).tag(file.quality)
                }
            }
            .scaledToFit()
            .pickerStyle(.segmented)
            .colorScheme(.light)
        }
        
        
    }
}

//struct QualitySelector_Previews: PreviewProvider {
//    static var previews: some View {
//        QualitySelector(capture: Capture())
//    }
//}
