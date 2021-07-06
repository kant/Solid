//
//  ImportOptionsView.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import SwiftUI
import RealmSwift
import RealityKit

struct ImportGalleryView: View {
    
    @ObservedObject var model: ContentViewModel
    @ObservedRealmObject var capture: Capture
    
    @ObservedObject var importConfiguration: ImportConfiguration
    
    let columns = [GridItem(), GridItem(spacing: 8), GridItem()]
    
    var body: some View {
        if let config = model.importConfiguration(for: capture) {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(config.previewImages) { previewImage in
                        AsyncImage(url: previewImage.url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        } placeholder: {
                            ProgressView()
                                .padding()
                        }
                    }
                }.padding()
            }
        } else {
            Text("Could not load ImportConfiguration 1")
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
