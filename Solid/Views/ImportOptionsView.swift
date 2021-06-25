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
    
    @StateObject var importConfiguration = ImportConfiguration()
    
    typealias Detail = PhotogrammetrySession.Request.Detail
    var body: some View {
        HStack {
            TextField("Capture Name: ", text: $capture.name)
            
            Toggle("basic test", isOn: $importConfiguration.testSelection.selected)
            Toggle("single element from array", isOn: $importConfiguration.qualitySelections.first!.selected)
            
            SwiftUI.List($importConfiguration.qualitySelections) { qualitySelection in
                Toggle(
                    "qualitySelection.quality.description",
                    isOn: qualitySelection.selected
                )
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

extension PhotogrammetrySession.Request.Detail: CustomStringConvertible, CaseIterable {
    public static var allCases: [PhotogrammetrySession.Request.Detail] = [
        .preview, .reduced, .medium, .full, .raw
    ]
    
    public var description: String {
        switch self {
        case .preview:
            return "Preview"
        case .reduced:
            return "Reduced"
        case .medium:
            return "Medium"
        case .full:
            return "Full"
        case .raw:
            return "Raw"
        @unknown default:
            return "unknown"
        }
    }
    
    
}

//struct ImportOptionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImportOptionsView(capture: Capture())
//    }
//}
