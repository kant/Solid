//
//  PreviewView.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import SwiftUI

struct PreviewView: View {

    var model: Model
    
    var body: some View {
        Text(model.name)
        Text(model.dateCreated.formatted())
        Text(model.dateCreated.formatted())
        Text(model.id.uuidString)
    }
}

struct PreviewView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView( model: Model() )   //.constant( )
    }
}
