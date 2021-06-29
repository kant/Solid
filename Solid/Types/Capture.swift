//
//  Model.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import Foundation
import RealityKit
import RealmSwift
import SwiftUI

@objcMembers class Capture: Object, ObjectKeyIdentifiable {
    @objc dynamic var id = ObjectId.generate()
    @objc dynamic var isInPreviewState = true
    
    @objc dynamic var dateCreated: Date
    @objc dynamic var dayCreated: Date
    @objc dynamic var name: String
    
    @objc dynamic var importFolderRelativePath: String
    let processedFiles = RealmSwift.List<ProcessedFile>()
    
    
    init(name: String, rawUrl: URL?) {
        self.name = name
        
        let date = Date()
        dateCreated = date
        let components = Calendar.current.dateComponents([.year, .month, .day], from: dateCreated)
        dayCreated = Calendar.current.date(from: components) ?? date
        
        self.importFolderRelativePath = rawUrl?.relativePath ?? ""
        //rawUrl?.absoluteString ?? ""
        
        super.init()
    }
    
    required convenience override init() {
        self.init(name: "New Model", rawUrl: nil)
    }
    
//    func url(for qualityLevel: PhotogrammetrySession.Request.Detail) -> URL? {
//        let selectedProcessedFile = processedFiles.first { processedFile in
//            processedFile.quality == qualityLevel
//        }
//        return selectedProcessedFile
//    }

    static func == (lhs: Capture, rhs: Capture) -> Bool {
        return lhs.id == rhs.id
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
