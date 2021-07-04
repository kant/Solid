//
//  Model.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import Foundation
import RealityKit
import RealmSwift
import SwiftUI

@objc enum CaptureState: Int {
    case configuring
    case processing
    case stored
}
extension CaptureState: CustomStringConvertible {
    var description: String {
        switch self {
        case .configuring:
            return "Configuring"
        case .processing:
            return "Processing"
        case .stored:
            return "Stored"
        }
    }
}

@objcMembers class Capture: Object, ObjectKeyIdentifiable {
    @objc dynamic var id = ObjectId.generate()
    
    @objc var state: CaptureState {
        get {
            return CaptureState(rawValue: stateValue) ?? .configuring
        }
        set {
            stateValue = newValue.rawValue
        }
    }
    @objc private dynamic var stateValue: Int = 0
    
    @objc dynamic var name: String
    @objc dynamic var dateCreated: Date
    lazy var formatedDate: String = {
        //display time created
        if Calendar.current.isDateInToday(dateCreated) {
            return dateCreated.formatted(date: .omitted, time: .shortened)
        } else {
            return dateCreated.formatted(date: .abbreviated, time: .omitted)
        }
        
        //unable to get .named to work
        //let dateFormater = RelativeDateTimeFormatter()
        //dateFormater.dateTimeStyle = .numeric
        //dateFormater.unitsStyle = .abbreviated
        //return dateFormater.localizedString(for: dateCreated, relativeTo: currentDate)
    }()
    
    @objc dynamic var importFolderRelativePath: String
    let processedFiles = RealmSwift.List<ProcessedFile>()
    
    
    init(name: String, rawUrl: URL?) {
        self.name = name
        
        let date = Date()
        dateCreated = date
        
        //dateCreated = Date(timeIntervalSince1970: 100) //long term debug date
        //dateCreated = Calendar.current.date(byAdding: .day, value: -5, to: Date())! //relative debug date
        
        self.importFolderRelativePath = rawUrl?.relativePath ?? ""
        
        super.init()
    }
    
    required convenience override init() {
        self.init(name: "New Model", rawUrl: nil)
    }

    static func == (lhs: Capture, rhs: Capture) -> Bool {
        return lhs.id == rhs.id
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    override class func ignoredProperties() -> [String] {
        return [#keyPath(formatedDate), #keyPath(state)]
    }
}
