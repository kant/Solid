//
//  ModelListCell.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import SwiftUI

struct ModelListCell: View {
    
    @ObservedObject var capture: Capture
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text(capture.name)
                if let day = capture.dayCreated {
                    Text(day.formatted(date: .abbreviated, time: .omitted))
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            if capture.isInPreviewState {
                Text("Preview")
                    .padding([.horizontal], 5)
                    .padding([.vertical], 2)
                    .foregroundStyle(.primary)
                    .background(.secondary)
                    .cornerRadius(5)
            }
        }
    }
}

struct ModelListCell_Previews: PreviewProvider {
    static var previews: some View {
        ModelListCell(capture: Capture())
    }
}
