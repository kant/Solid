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
    
    @EnvironmentObject private var model: ContentViewModel
    @ObservedRealmObject var capture: Capture
    
    @ObservedObject var importConfiguration: ImportConfiguration
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                
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
                HStack(alignment: .top) {
                    Text("# of Images:")
                        .bold()
                    Text("_ Images") //add num of pics etc
                }
                .font(.subheadline)
            }
            
            if let importConfiguration = importConfiguration {

                VStack(alignment: .leading) {
                    ForEach(importConfiguration.qualitySelections.indices) { index in
                        Toggle(
                            importConfiguration.qualitySelections[index].name,
                            isOn: $importConfiguration.qualitySelections[index].selected
                        )
                    }
                }
                .padding([.horizontal])
                
            } else {
                Text("Could not load ImportConfiguration 2")
            }
            
            Button {
                model.processWithOptions(capture)
            } label: {
                Text("Generate Full")
            }
        }
//        .padding()
    }
}

extension PhotogrammetrySession.Request.Detail: CaseIterable {
    public static var allCases: [PhotogrammetrySession.Request.Detail] = [
        .preview, .reduced, .medium, .full, .raw
    ]
}

struct ImportOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        let capture = Capture(
            name: "Testing",
            rawUrl: URL(string: "url/")
        )
        ImportOptionsView(
            capture: capture,
            importConfiguration: ImportConfiguration(for: capture)
        )
    }
}
