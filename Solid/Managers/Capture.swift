//
//  Model.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import Foundation
import RealityKit

class Capture: Identifiable, Hashable, ObservableObject {
    
    @Published var isInPreviewState = true
    
    let id = UUID()
    var dateCreated: Date
    var dayCreated: Date?
    var name: String
    
//    var availableQualityLevels: [PhotogrammetrySession] = []
//    var importConfiguration: ImportConfiguration?
    
    init(name: String) {
        self.name = name
        
        dateCreated = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: dateCreated)
        dayCreated = Calendar.current.date(from: components)
    }
    
    convenience init() {
        self.init(name: "Test Model")
    }
    
    static func == (lhs: Capture, rhs: Capture) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(dateCreated)
        hasher.combine(name)
        hasher.combine(isInPreviewState)
    }
    
}
