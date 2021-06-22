//
//  Model.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import Foundation
import RealityKit
import RealmSwift

class Capture: Object, Identifiable {
    
    @Published @objc dynamic var isInPreviewState = true
    
    @objc dynamic var dateCreated: Date
    @objc dynamic var dayCreated: Date
    @objc dynamic var name: String
    
    var importConfiguration = ImportConfiguration()
    let processedFiles = List<ProcessedFile>()
    
    init(name: String, importFolderUrl: URL?) {
        self.name = name

        importConfiguration.folderUrl = importFolderUrl
        
        let date = Date()
        dateCreated = date
        let components = Calendar.current.dateComponents([.year, .month, .day], from: dateCreated)
        dayCreated = Calendar.current.date(from: components) ?? date
    }
    
    required convenience init() {
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
}
