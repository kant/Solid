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
}
