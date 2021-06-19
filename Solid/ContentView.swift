//
//  ContentView.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/18/21.
//

import SwiftUI

struct ContentView: View {
    
    var storage: Storage
    
    @State private var selectedModel: Model?
    
    var body: some View {
        NavigationView {
            
            List(storage.models, id: \.id) { model in
                NavigationLink(
                    destination: PreviewView(model: model),
                    tag: model,
                    selection: $selectedModel,
                    label: {
                        ModelListCell(model: model)
                    }
                )
            }
            .listStyle(.sidebar)
        }
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.destructiveAction) {
                Button(action: {
                    debugPrint("delete \(selectedModel?.name ?? "no name model")")
                }, label: {
                    Image(systemName: "trash")
                })
            }
            
            ToolbarItem(placement: ToolbarItemPlacement.primaryAction) {
                Button(action: {
                    debugPrint("add new")
                }, label: {
                    Image(systemName: "plus")
                })
            }
            
            ToolbarItem {
                Button(action: {
                    debugPrint("sharing \(selectedModel?.name ?? "no name model")")
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                })
            }
        }
        .navigationTitle(selectedModel?.name ?? "")
        .navigationSubtitle(selectedModel?.dateCreated.formatted(date: .abbreviated, time: .shortened) ?? "")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(storage: Storage())
    }
}
