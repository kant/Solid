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
        HStack {
            VStack {
                TextField("Capture Name: ", text: $capture.name)
                if let folderUrl = importConfiguration.folderUrl {
                    Text(folderUrl.path)
                }
                Text("_ Images") //add num of pics etc
            }
            
            if let importConfiguration = importConfiguration {
                SwiftUI.List {
                    ForEach(importConfiguration.qualitySelections.indices) { index in
                        Toggle(
                            importConfiguration.qualitySelections[index].name,
                            isOn: $importConfiguration.qualitySelections[index].selected
                        )
                    }
                }
            } else {
                Text("Could not load ImportConfiguration 2")
            }
            
            Button {
                model.processWithOptions(capture)
            } label: {
                Text("Generate Full")
            }
        }
        .padding()
    }
}

extension PhotogrammetrySession.Request.Detail: CaseIterable {
    public static var allCases: [PhotogrammetrySession.Request.Detail] = [
        .preview, .reduced, .medium, .full, .raw
    ]
}

//struct ImportOptionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImportOptionsView(capture: Capture())
//    }
//}
