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
    
    lazy var previewImages: [PreviewImage] = {
        
        var previews: [PreviewImage] = []
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: relativePath)
            for path in contents {
                let folderUrl = URL(fileURLWithPath: relativePath)
                previews.append(
                    PreviewImage(url: URL(fileURLWithPath: path, relativeTo: folderUrl) )
                )
            }
        } catch {
            return previews
        }
        return previews
        
    }()
    
    @Published var qualitySelections: [QualitySelection] = {
        var selections: [QualitySelection] = []
        for qualityLevel in PhotogrammetrySession.Request.Detail.allCases {
            let selection = QualitySelection(quality: qualityLevel)
            if qualityLevel == .preview {
                selection.selected = true
            }
            selections.append(selection)
        }
        return selections
    }()
    var numberOfQualitiesSelected: Int {
        var selectedCount = 0
        for selection in qualitySelections {
            if selection.selected {
                selectedCount += 1
            }
        }
        return selectedCount
    }
    
    @Published var wantsUsdaAndObjOutput = false
    
    
    init(for capture: Capture) {
        self.captureId = capture._id
        

        relativePath = capture.importFolderRelativePath
        rawFolderUrl = URL(
            fileURLWithPath: capture.importFolderRelativePath,
            relativeTo: FileManager().homeDirectoryForCurrentUser
        )
    }
    
    func numberOfImages() -> Int? {
        do {
            return try FileManager.default.contentsOfDirectory(atPath: relativePath).count
        } catch {
            return nil
        }
    }
        
}

struct PreviewImage: Identifiable {
    let id = UUID()
    var url: URL
}

class QualitySelection: Identifiable, ObservableObject, Equatable {
    static func == (lhs: QualitySelection, rhs: QualitySelection) -> Bool {
        lhs.quality == rhs.quality && lhs.selected == rhs.selected //should include id?
    }
    
    var id = UUID()
    
    var quality: PhotogrammetrySession.Request.Detail
    var selected: Bool = false
    
    init(quality: PhotogrammetrySession.Request.Detail) {
        self.quality = quality
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
