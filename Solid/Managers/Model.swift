//
//  Modl.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import Foundation
import RealityKit

class Model: NSObject, ObservableObject {
    
    var storage: Storage
    var captureImporting: Capture?
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    func newCapture(with folderUrl: URL) {
        var capture = Capture(name: "New Model")
//        capture.tempFolderUrl = folderUrl
        captureImporting = capture
        storage.models.append(capture)
    }
    
    func processWithOptions(capture: Capture) {
        capture.isInPreviewState = false
        debugPrint("process \(capture.name) with options")
    }
}
