//
//  Modl.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import Foundation

class ContentViewModel: NSObject, ObservableObject {
    
    var storage: Storage
    var viewportModel = ViewportModel()
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    func processWithOptions(capture: Capture) {
        capture.isInPreviewState = false
        debugPrint("process \(capture.name) with options")
    }
}
