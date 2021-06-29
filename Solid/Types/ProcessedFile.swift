//
//  ProcessedFile.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/21/21.
//

import Foundation
import RealmSwift
import RealityKit

class ProcessedFile: Object, Identifiable {
    var quality: PhotogrammetrySession.Request.Detail {
        get { return PhotogrammetrySession.Request.Detail(rawValue: rawQuality) ?? .preview }
        set { rawQuality = newValue.rawValue }
    }
    @objc private dynamic var rawQuality: Int = 0
    
    convenience init(quality: PhotogrammetrySession.Request.Detail) {
        self.init()
        self.quality = quality
    }
    
}
