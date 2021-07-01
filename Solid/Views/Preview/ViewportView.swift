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
    
    @Environment(\.colorScheme) var colorScheme
    
    var selectedPreviewQuality: PhotogrammetrySession.Request.Detail?
    
    init(model: ContentViewModel, capture: Capture, selectedPreviewQuality: PhotogrammetrySession.Request.Detail?) {
        self.model = model
        self.selectedPreviewQuality = selectedPreviewQuality
        
        self.model.viewportModel.capture = capture
    }
    
    var body: some View {
        SceneView(
            scene: model.viewportModel.scene(with: selectedPreviewQuality, colorScheme: colorScheme),
            pointOfView: model.viewportModel.cameraNode,
            options: [.allowsCameraControl],
            delegate: model.viewportModel
        )
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

