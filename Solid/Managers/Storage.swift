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
            Capture(name: "Model 1"),
            Capture(name: "Model 2"),
            Capture(name: "Model 3"),
            Capture(name: "Model 4")
        ])
        
    }
}
