//
//  Storage.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import Foundation

class Storage {
    var models: [Model] = []
    
    init() {
        models.append(contentsOf: [
            Model(name: "Model 1"),
            Model(name: "Model 2"),
            Model(name: "Model 3"),
            Model(name: "Model 4")
        ])
    }
}
