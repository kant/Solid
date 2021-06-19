//
//  Model.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import Foundation

struct Model: Identifiable, Hashable {
    let id = UUID()
    
    var dateCreated: Date
    var dayCreated: Date?
    
    var name: String
    
    init(name: String) {
        self.name = name
        
        dateCreated = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: dateCreated)
        dayCreated = Calendar.current.date(from: components)
    }
    
    init() {
        self.init(name: "Test Model")
    }
}
