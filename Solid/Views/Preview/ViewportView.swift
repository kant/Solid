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
    
    
    @ObservedObject var viewportModel: ViewportModel
    @ObservedRealmObject var capture: Capture
    
    @Binding var selectedPreviewQuality: PhotogrammetrySession.Request.Detail
    
    //@Environment(\.colorScheme) var colorScheme: ColorScheme
//    @AppStorage("wantsDOF") var wantsDOF = false
//    @AppStorage("enviromentRotation") var enviromentRotation = 0.0
//    @AppStorage("enviromentBrightness") var enviromentBrightness = 1.0
    
    //var sceneViewRepresentable: SceneViewRepresentable?
    
//    init(model: ContentViewModel, capture: Capture, lightingRotationAngle: Double) {
//        self.lightingRotationAngle = lightingRotationAngle
//        self.model = model
//        self.model.viewportModel.capture = capture
//
//    }
    
    var body: some View {
        //HStack {
            SceneViewRepresentable(
                viewportModel: viewportModel,
                capture: capture,
                selectedPreviewQuality: $selectedPreviewQuality
            )
            
//            VStack {
//                Toggle("wantsDOF", isOn: $wantsDOF)
//                Slider(value: $lightingRotationAngle, in: 0...1) {
//                    Text("lightingRotationAngle")
//                }
//            }
//            SceneView(
//                scene: model.viewportModel.scene(colorScheme: colorScheme, wantsDOF: wantsDOF),
//                pointOfView: model.viewportModel.cameraNode,
//                options: [.allowsCameraControl],
//                delegate: model.viewportModel
//            )
//            Text("wants dof: \(wantsDOF.description)")
//                .foregroundColor(.white)
        //}
    }
    
//    static func == (lhs: ViewportView, rhs: ViewportView) -> Bool {
//        let captureIdIsEqual = lhs.model.viewportModel.capture?.id == rhs.model.viewportModel.capture?.id
//        debugPrint("captureIdIsEqual \(captureIdIsEqual)")
//        let captureProcessedFilesIsEqual = lhs.model.viewportModel.capture?.processedFiles == rhs.model.viewportModel.capture?.processedFiles
//        debugPrint("captureProcessedFilesIsEqual \(captureProcessedFilesIsEqual)")
//        let selectedQualityIsEqual = lhs.selectedPreviewQuality == rhs.selectedPreviewQuality
//        debugPrint("selectedQualityIsEqual \(selectedQualityIsEqual)")
//
//        return  captureIdIsEqual && captureProcessedFilesIsEqual && selectedQualityIsEqual
//    }
    
}

