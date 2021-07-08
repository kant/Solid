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
    
    var body: some View {
        ZStack {
            SceneViewRepresentable(
                viewportModel: viewportModel,
                capture: capture,
                selectedPreviewQuality: selectedPreviewQuality
            )
//            if viewportModel.isLoading {
//                ProgressView()
//                    .padding()
//                    .background(.regularMaterial)
//                    .cornerRadius(10)
//            }
        }
    }
}

