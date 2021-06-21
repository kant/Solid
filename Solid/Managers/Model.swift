//
//  Modl.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import Foundation

class Model: NSObject, ObservableObject {
    
    var storage: Storage
    var viewportModel = ViewportModel()
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    func newCapture(with folderUrl: URL) {
        let capture = Capture(name: "New Model", importFolderUrl: folderUrl)
        storage.models.append(capture)
    }
    
    func processWithOptions(capture: Capture) {
        capture.isInPreviewState = false
        debugPrint("process \(capture.name) with options")
    }
}
