//
//  Modl.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import Foundation
import RealmSwift

class ContentViewModel: NSObject, ObservableObject {
    
    var storage: Storage
    var viewportModel = ViewportModel()
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    func processWithOptions(_ capture: Capture) {
        objectWillChange.send()
        do {
            try storage.realm.write {
                if let thawedCapture = capture.thaw() {
                    thawedCapture.isInPreviewState = false
                }
            }
        } catch {
            debugPrint("problem")
        }
        debugPrint("begin processing with options")
    }
}
