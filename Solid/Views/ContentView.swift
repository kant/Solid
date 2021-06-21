//
//  ContentView.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/18/21.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    
    @EnvironmentObject private var model: Model
    
    @State private var selectedCapture: Capture?
    
    @State private var displayFileBrowser: Bool = false
    @State private var displayImportOptions: Bool = false
    
    var body: some View {
        
        //List & Preview View
        NavigationView {
            List(model.storage.models, id: \.id) { capture in
                NavigationLink(
                    destination:
                        PreviewView(capture: capture),
                    tag: capture,
                    selection: $selectedCapture,
                    label: {
                        ModelListCell(capture: capture)
                    }
                )
            }
            .listStyle(.sidebar)
        }
        
        //File Import
        .fileImporter(
            isPresented: $displayFileBrowser,
            allowedContentTypes: [UTType.folder],
            allowsMultipleSelection: false,
            onCompletion: { result in
                do  {
                    let url = try result.get()
                    debugPrint(url)
                    if let firstUrl = url.first {
                        model.newCapture(with: firstUrl)
                    }
                } catch {
                    debugPrint("error with importing")
                }
            }
        )
        
        //Toolbar
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.destructiveAction) {
                Button(action: {
                    debugPrint("delete \(selectedCapture?.name ?? "no name model")")
                }, label: {
                    Image(systemName: "trash")
                })
            }
            
            ToolbarItem(placement: ToolbarItemPlacement.primaryAction) {
                Button(action: {
                    displayFileBrowser = true
                }, label: {
                    Image(systemName: "plus")
                })
            }
            
            ToolbarItem {
                Button(action: {
                    debugPrint("sharing \(selectedCapture?.name ?? "no name model")")
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                })
            }
        }
        
        //Navigation Title / Subtitle
        .navigationTitle(selectedCapture?.name ?? "")
        .navigationSubtitle(selectedCapture?.dateCreated.formatted(date: .abbreviated, time: .shortened) ?? "")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Model(storage: Storage()))
    }
}
