//
//  ContentView.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/18/21.
//

import SwiftUI
import RealmSwift
import UniformTypeIdentifiers

struct ContentView: View {
    
    @ObservedObject var model: ContentViewModel
    
    @State private var selectedCapture: Capture?
    
    @State private var displayFileBrowser: Bool = false

    @ObservedResults(Capture.self, sortDescriptor: SortDescriptor(keyPath: "dateCreated", ascending: false)) var captures
    
    var body: some View {
        
        //List & Preview View
        NavigationView {
            List(selection: $selectedCapture) {
                ForEach(captures) { capture in
                    NavigationLink(destination: PreviewView(model: model, capture: capture)) {
                        ModelListCell(capture: capture)
                    }.tag(capture)
                }
            }
            .listStyle(.sidebar)
        }
        
        //Toolbar
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigation) {
                Button(action: {
                    //from https://developer.apple.com/forums/thread/651807?answerId=617555022#617555022
                    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                }, label: {
                    Image(systemName: "sidebar.left")
                })
            }
            
            ToolbarItem(placement: ToolbarItemPlacement.destructiveAction) {
                Button(action: {
                    guard let selectedCapture = selectedCapture else { return }
                    debugPrint("delete \(selectedCapture.name)")
                }, label: {
                    Image(systemName: "trash")
                })
            }

            ToolbarItem(placement: ToolbarItemPlacement.automatic) {
                Button(action: {
                    guard let selectedCapture = selectedCapture else { return }
                    debugPrint("sharing all quality levels of \(selectedCapture.name)")
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                })
            }

            ToolbarItem(placement: ToolbarItemPlacement.primaryAction) {
                Button(action: {
                    displayFileBrowser = true
                }, label: {
                    Image(systemName: "plus")
                })
            }

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
                        let capture = Capture(name: "New Model", rawUrl: firstUrl)
                        $captures.append(capture)
                        model.importConfigurations.append(
                            ImportConfiguration(for: capture)
                        )
                    }
                } catch {
                    debugPrint("error with importing")
                }
            }
        )
        
        //Navigation Title / Subtitle
        .navigationTitle(selectedCapture?.name ?? "")
        .navigationSubtitle(selectedCapture?.dateCreated.formatted(date: .abbreviated, time: .shortened) ?? "")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let model: ContentViewModel = {
            let realm = try! Realm()
            let storage = Storage(with: realm)
            return ContentViewModel(storage: storage)
        }()
        ContentView(model: model)
    }
}
