//
//  ImportOptionsView.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import SwiftUI
import RealmSwift
import RealityKit

struct ImportOptionsView: View {
    
    @ObservedObject var model: ContentViewModel
    @ObservedRealmObject var capture: Capture
    
    @ObservedObject var importConfiguration: ImportConfiguration
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            //Name
            TextField("Capture Name: ", text: $capture.name)
                .font(.headline)
                .textFieldStyle(.roundedBorder)
            
            
            //Folder Url
            if let _ = importConfiguration.rawFolderUrl {
                HStack(alignment: .top) {
                    Text("Folder Location:")
                        .bold()
                    Text(importConfiguration.relativePath)
                }
                .font(.subheadline)
            } else {
                Text("Relink Folder")
            }
            
            //Number of Images
            if let numberOfImages = importConfiguration.numberOfImages() {
                Text("\(numberOfImages) Images")
            }
            
            
            
            //Quality Toggles
            VStack(alignment: .leading) {
                ForEach(importConfiguration.qualitySelections.indices) { index in
                    Toggle(
                        importConfiguration.qualitySelections[index].quality.name,
                        isOn: $importConfiguration.qualitySelections[index].selected
                    )
                }
            }
            .padding()
            
            //Generate Button
            Button {
                model.captureGenerators.append(
                    CaptureGenerator(for: capture, with: importConfiguration, model: model)
                )
            } label: {
                Text("Generate Model")
            }
        }
    }
}

extension PhotogrammetrySession.Request.Detail: CaseIterable {
    public static var allCases: [PhotogrammetrySession.Request.Detail] = [
        .preview, .reduced, .medium, .full, .raw
    ]
}

//struct ImportOptionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        let capture = Capture(
//            name: "Testing",
//            rawUrl: URL(string: "url/")
//        )
//        ImportOptionsView(
//            model: ContentViewModel(storage: Storage(with: try! Realm())),
//            capture: capture,
//            importConfiguration: ImportConfiguration(for: capture)
//        )
//    }
//}
