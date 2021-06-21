//
//  ImportOptionsView.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import SwiftUI

struct ImportOptionsView: View {
    
    @EnvironmentObject private var model: Model
    @ObservedObject var capture: Capture
    
    var body: some View {
        Divider()
        VStack {
            Text("Import Options")
            //generate button
            Button {
                model.processWithOptions(capture: capture)
            } label: {
                Text("Generate Full")
            }
        }
        .padding()
        
        
    }
}

struct ImportOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        ImportOptionsView(capture: Capture())
    }
}
