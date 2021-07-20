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
    
    @ObservedObject var model: MainViewModel
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
            Text("Could not load ImportConfiguration")
        }
    }
}
