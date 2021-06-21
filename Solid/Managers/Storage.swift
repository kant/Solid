//
//  Storage.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import Foundation
import SwiftUI

class Storage {
    var models: [Capture] = []
    
    init() {
        models.append(contentsOf: [
            Capture(name: "Model 1", importFolderUrl: nil),
            Capture(name: "Model 2", importFolderUrl: nil),
            Capture(name: "Model 3", importFolderUrl: nil),
            Capture(name: "Model 4", importFolderUrl: nil)
        ])
        
    }
}
