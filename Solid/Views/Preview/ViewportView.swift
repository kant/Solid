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

struct ViewportView: View, Equatable {
    
    @ObservedObject var model: ContentViewModel
    
    var selectedPreviewQuality: PhotogrammetrySession.Request.Detail
    
    init(model: ContentViewModel, capture: Capture, selectedPreviewQuality: PhotogrammetrySession.Request.Detail) {
        self.model = model
        self.selectedPreviewQuality = selectedPreviewQuality
        
        self.model.viewportModel.capture = capture
    }
    
    var body: some View {
        SceneView(
            scene: model.viewportModel.scene(with: selectedPreviewQuality),
            pointOfView: model.viewportModel.cameraNode,
            options: [.allowsCameraControl, .autoenablesDefaultLighting]
        )
    }
    
    static func == (lhs: ViewportView, rhs: ViewportView) -> Bool {
        return lhs.model.viewportModel.capture?.id == rhs.model.viewportModel.capture?.id && lhs.model.viewportModel.capture?.processedFiles == rhs.model.viewportModel.capture?.processedFiles && lhs.selectedPreviewQuality == rhs.selectedPreviewQuality
    }
    
}

