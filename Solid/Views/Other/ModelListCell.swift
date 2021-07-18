//
//  ModelListCell.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import SwiftUI
import RealmSwift

struct ModelListCell: View {
    
//    /@ObservedObject private var model: ContentViewModel
    @ObservedRealmObject var capture: Capture
    //@State var captureName: String
    
//    init(capture: Capture, model: ContentViewModel) {
//        self.capture = capture
//        self.model = model
//        captureName = "capture.name"
//    }
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                TextField("", text: $capture.name)
                    .textFieldStyle(.plain)

//                TextField("", text: $captureName, onEditingChanged: {_ in }) {
//                    //model.storage.changeName(for: capture, to: captureName)
//                    $capture.name = $captureName
//                }

                Text(capture.formatedDate)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            if capture.state != .stored {
                Text(capture.state.description)
                .padding([.horizontal], 5)
                .padding([.vertical], 2)
                .foregroundStyle(.primary)
                .background(.gray)
                .cornerRadius(5)
            }
        }
    }
}
