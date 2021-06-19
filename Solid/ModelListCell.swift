//
//  ModelListCell.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import SwiftUI

struct ModelListCell: View {
    
    var model: Model
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.name)
            if let day = model.dayCreated {
                Text(day.formatted(date: .abbreviated, time: .omitted))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct ModelListCell_Previews: PreviewProvider {
    static var previews: some View {
        ModelListCell(model: Model())
    }
}
