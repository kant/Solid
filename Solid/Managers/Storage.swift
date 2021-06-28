//
//  Storage.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import Foundation
import SwiftUI
import RealmSwift

class Storage {
    var realm: Realm
    
    init(with realm: Realm) {
        self.realm = realm
    }
    
    func newCapture(with folderUrl: URL) {
        let capture = Capture(name: "New Model", rawUrl: folderUrl)
        try! realm.write {
            realm.add(capture)
        }
    }
    
    static private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func url(for selection: QualitySelection) -> URL {
        return getDocumentsDirectory().appendingPathComponent("\(selection.id)_\(selection.quality.name).usdz")
    }
}
