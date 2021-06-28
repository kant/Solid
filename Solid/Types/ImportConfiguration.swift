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

class ImportConfiguration: ObservableObject, Equatable {
    static func == (lhs: ImportConfiguration, rhs: ImportConfiguration) -> Bool {
        lhs.captureId == rhs.captureId && lhs.qualitySelections == rhs.qualitySelections
    }
    
    var captureId: ObjectId
    
    var rawFolderUrl: URL?
    var relativePath: String
    
    @Published var qualitySelections: [QualitySelection] = {
        var selection: [QualitySelection] = []
        for qualityLevel in PhotogrammetrySession.Request.Detail.allCases {
            selection.append(
                QualitySelection(quality: qualityLevel)
            )
        }
        return selection
    }()
    
    init(for capture: Capture) {
        self.captureId = capture.id
        

        relativePath = capture.importFolderRelativePath
        rawFolderUrl = URL(
            fileURLWithPath: capture.importFolderRelativePath,
            relativeTo: FileManager().homeDirectoryForCurrentUser
        )
    }
}

class QualitySelection: Identifiable, ObservableObject, Equatable {
    static func == (lhs: QualitySelection, rhs: QualitySelection) -> Bool {
        lhs.quality == rhs.quality && lhs.selected == rhs.selected //should include id?
    }
    
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
