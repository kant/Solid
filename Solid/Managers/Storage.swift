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
    let realm = try! Realm()
    
    lazy var captures: RealmSwift.List<Capture> = {
        let list = RealmSwift.List<Capture>()
        try! realm.write {
            list.append(Capture(name: "1", importFolderUrl: nil))
            list.append(Capture(name: "2", importFolderUrl: nil))
            list.append(Capture(name: "3", importFolderUrl: nil))
        }
        return list
//        let objects = realm.objects(Capture.self)
//        let sorted = objects.sorted(byKeyPath: "dateCreated", ascending: false)
//        return sorted
    }()
    
    init() {
//        try! realm.write {
//            realm.add( Capture() )
//        }
    }
    
    func newCapture(with folderUrl: URL) {
        let capture = Capture(name: "New Model", importFolderUrl: folderUrl)
        try! realm.write {
            realm.add(capture)
        }
    }
}
