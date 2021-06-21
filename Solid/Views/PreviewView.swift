//
//  PreviewView.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import SwiftUI

struct PreviewView: View {

    @EnvironmentObject private var model: Model
    @ObservedObject var capture: Capture
    
    var body: some View {
        
        Text("Preview Model")
        Text(capture.name)
        Text(capture.dateCreated.formatted())
        Text(capture.dateCreated.formatted())
        Text(capture.id.uuidString)
        
        if capture.isInPreviewState {
            ImportOptionsView(capture: capture)
        }
        
    }
}

struct PreviewView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView( capture: Capture() )   //.constant( )
    }
}


