//
//  ImportConfiguration.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/20/21.
//

import Foundation
import RealityKit
import SwiftUI

class ImportConfiguration: ObservableObject {
    
    var folderUrl: URL?
    @Published var testSelection = QualitySelection(quality: .preview)
    @Published var qualitySelections: [QualitySelection] = {
        var selection: [QualitySelection] = []
        for qualityLevel in PhotogrammetrySession.Request.Detail.allCases {
            selection.append( QualitySelection(quality: qualityLevel) )
        }
        return selection
    }()
}

class QualitySelection: Identifiable {
    var id = UUID()
    
    var quality: PhotogrammetrySession.Request.Detail
    var selected: Bool = false
    
    init(quality: PhotogrammetrySession.Request.Detail) {
        self.quality = quality
    }
}
