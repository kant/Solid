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
    
    @AppStorage("lightingEnviroment") var lightingEnviroment = Defaults.lightingEnviroment
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
            .popover(isPresented: $showLightingPopover, arrowEdge: .top) {
                VStack {
                    Text("Enviroment")
                        .font(.headline)
                    
                    //making custom grid becuase weird animation glitch with LazyVGrid
                    VStack {
                        ForEach(0..<2) { row in
                            HStack {
                                ForEach(0..<2) { column in
                                    
                                    let item = LightingEnviroment.allCases[row * 2 + column]
                                    let selected = lightingEnviroment.rawValue == item.rawValue
                                    
                                    Button {
                                        lightingEnviroment = item
                                    } label: {
                                        ZStack {
                                            Image("lightingEnviroment_\(item.rawValue)")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .cornerRadius(8)
                                                .opacity(selected ? 0.5 : 1)
                                            Image(systemName: "checkmark")
                                                .font(.body.weight(.bold))
                                                .opacity(selected ? 1 : 0)
                                            
                                        }
                                    }
                                    .buttonStyle(.plain)
                                    
                                }
                            }
                        }
                    }
                    .frame(width: 90*2, height: 60*2)
                    .animation(.default, value: lightingEnviroment)
                    
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
