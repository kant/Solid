//
//  ImportOptionsView.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import SwiftUI
import RealmSwift
import RealityKit

struct ConfigurationView: View {
    
    @ObservedObject var model: MainViewModel
    @ObservedRealmObject var capture: Capture
    
    @ObservedObject var importConfiguration: ImportConfiguration
    
    var body: some View {
        HStack {
            ImportGalleryView(model: model, capture: capture, importConfiguration: importConfiguration)
            ImportOptionsView(model: model, capture: capture, importConfiguration: importConfiguration)
                .padding()
        }
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
