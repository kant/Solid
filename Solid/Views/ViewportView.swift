//
//  ViewportView.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/20/21.
//

import SwiftUI
import SceneKit
import RealityKit

struct ViewportView: View {
    
    @EnvironmentObject private var model: Model
    var viewportModel: ViewportModel {
        return model.viewportModel
    }
    
    @Binding var selectedPreviewQuality: PhotogrammetrySession.Request.Detail
    
//    init(for capture: Capture) {
//        viewportModel.capture = capture
//    }
    
    var body: some View {
        SceneView(
            scene: viewportModel.scene(with: selectedPreviewQuality),
            pointOfView: viewportModel.cameraNode,
            options: [.allowsCameraControl, .autoenablesDefaultLighting]
        )
    }
}

