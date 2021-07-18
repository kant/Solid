//
//  Modl.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import Foundation
import SwiftUI
import RealmSwift
import Combine

class ContentViewModel: NSObject, ObservableObject {
    
    var storage: Storage
    var viewportModel = ViewportModel()
    
    var importConfigurations: [ImportConfiguration] = []
    var captureGenerators: [CaptureGenerator] = []
    var captureGeneratorSubscriptions: Set<AnyCancellable> = []
    
    @Published var currentlyProcessingProgress: Double?
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    func importConfiguration(for capture: Capture) -> ImportConfiguration? {
    
        let existingConfig = importConfigurations.first { config in
            config.captureId == capture._id
        }
        
        //return existing config
        if let existingConfig = existingConfig {
            return existingConfig
        
        //create new import config
        } else {
            let newConfig = ImportConfiguration(for: capture)
            importConfigurations.append(newConfig)
            return newConfig
        }
    }
    
    
}
