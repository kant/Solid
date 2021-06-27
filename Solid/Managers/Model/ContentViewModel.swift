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
    
    var importConfigurations: [ImportConfiguration] = []
    
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
    
    
    func importConfiguration(for capture: Capture) -> ImportConfiguration? {
    
        let existingConfig = importConfigurations.first { config in
            config.captureId == capture.id
        }
        
        //return existing config
        if let existingConfig = existingConfig {
            return existingConfig
        
        //create new import config
        } else {
            let newConfig = ImportConfiguration(id: capture.id)
            importConfigurations.append(newConfig)
            return newConfig
        }
    }
}
