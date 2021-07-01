//
//  PreviewContent.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/30/21.
//

import Foundation
import RealmSwift

class PreviewContent {
    let realm = try! Realm()
    var storage: Storage
    var contentViewModel: ContentViewModel
    
    static var capture: Capture {
        let capture = Capture()
        capture.processedFiles.append(objectsIn: [
            ProcessedFile(quality: .preview),
            ProcessedFile(quality: .medium),
            ProcessedFile(quality: .full)
        ])
        capture.isInPreviewState = false
        return capture
    }
    
    init() {
        storage = Storage(with: realm)
        contentViewModel = ContentViewModel(storage: storage)
    }
}
