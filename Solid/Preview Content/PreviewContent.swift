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
    var contentViewModel: MainViewModel
    
    static var capture: Capture {
        let capture = Capture()
        capture.processedFiles.append(objectsIn: [
            ProcessedFile(quality: .preview),
            ProcessedFile(quality: .medium),
            ProcessedFile(quality: .full)
        ])
        capture.state = .configuring
        return capture
    }
    
    init() {
        storage = Storage(with: realm)
        contentViewModel = MainViewModel(storage: storage)
    }
}
