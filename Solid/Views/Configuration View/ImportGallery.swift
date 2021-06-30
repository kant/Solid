//
//  ImportOptionsView.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import SwiftUI
import RealmSwift
import RealityKit

struct ImportGallery: View {
    
    @ObservedObject var model: ContentViewModel
    @ObservedRealmObject var capture: Capture
    
    @ObservedObject var importConfiguration: ImportConfiguration
    
    var body: some View {
        Text("Import Gallery")
    }
}

//struct ImportOptionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        let capture = Capture(
//            name: "Testing",
//            rawUrl: URL(string: "url/")
//        )
//        ImportOptionsView(
//            model: ContentViewModel(storage: Storage(with: Realm())),
//            capture: capture,
//            importConfiguration: ImportConfiguration(for: capture)
//        )
//    }
//}
