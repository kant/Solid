//
//  Model.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import Foundation
import RealityKit

struct ProcessedFile: Hashable, Identifiable {
    var id: ObjectIdentifier
    
    var location: URL
    var qualityName: String
    var quality: PhotogrammetrySession.Request.Detail
}

class Capture: Identifiable, Hashable, ObservableObject {
    
    @Published var isInPreviewState = true
    
    let id = UUID()
    var dateCreated: Date
    var dayCreated: Date?
    var name: String
    
    var importConfiguration = ImportConfiguration()
    var processedFiles: [ProcessedFile] = []
    
    init(name: String, importFolderUrl: URL?) {
        self.name = name

        importConfiguration.folderUrl = importFolderUrl
        
        dateCreated = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: dateCreated)
        dayCreated = Calendar.current.date(from: components)
    }
    
    convenience init() {
        self.init(name: "New Model", importFolderUrl: nil)
    }
    
    
    
    
    func url(for qualityLevel: PhotogrammetrySession.Request.Detail) -> URL? {
        let selectedProcessedFile = processedFiles.first { processedFile in
            processedFile.quality == qualityLevel
        }
        
        return selectedProcessedFile?.location
    }
    
    
    
    static func == (lhs: Capture, rhs: Capture) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(dateCreated)
        hasher.combine(name)
        hasher.combine(isInPreviewState)
    }
    
}
