//
//  ImportConfiguration.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/20/21.
//

import Foundation
import RealityKit
import SwiftUI
import RealmSwift

class ImportConfiguration: ObservableObject {
    var captureId: ObjectId
    
    var folderUrl: URL?
    
    @Published var qualitySelections: [QualitySelection] = {
        var selection: [QualitySelection] = []
        for qualityLevel in PhotogrammetrySession.Request.Detail.allCases {
            selection.append(
                QualitySelection(quality: qualityLevel)
            )
        }
        return selection
    }()
    
//    init(id: ObjectId, folderUrl: URL) {
//        self.captureId = id
//        self.folderUrl = folderUrl
//    }
    
    init(for capture: Capture) {
        self.captureId = capture.id
        self.folderUrl = URL(string: capture.importFolderUrl)
    }
}

class QualitySelection: Identifiable, ObservableObject {
    var id = UUID()
    
    var quality: PhotogrammetrySession.Request.Detail
    var name: String
    var selected: Bool = false
    
    init(quality: PhotogrammetrySession.Request.Detail) {
        self.quality = quality
        self.name = quality.name
    }
}

extension PhotogrammetrySession.Request.Detail {
    var name: String {
        switch self {
        case .preview:
            return "Preview"
        case .reduced:
            return "Reduced"
        case .medium:
            return "Medium"
        case .full:
            return "Full"
        case .raw:
            return "Raw"
        @unknown default:
            return "Unknown"
        }
    }
}
