//
//  ContentView.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/18/21.
//

import SwiftUI
import RealmSwift
import UniformTypeIdentifiers

struct MainView: View {
    
    @ObservedObject var model: ContentViewModel
    
    @State private var selectedCaptureID: ObjectId?
    var selectedCapture: Capture? {
        return group.captures.first { capture in
            capture._id == selectedCaptureID
        }
    }
    
    @State private var importFileBrowserDisplayed: Bool = false
    @State private var fileExportIsDisplayed: Bool = false

    //@ObservedResults(Capture.self, sortDescriptor: SortDescriptor(keyPath: "dateCreated", ascending: false)) var captures
    @ObservedRealmObject var group: CaptureGroup
    
//    init(model: ContentViewModel) {
//        self.model = model
//        
//    }
    
    var body: some View {
//        if let group = captureGroups.first {
            //List & Preview View
        CaptureNavigationView(selectedCaptureID: $selectedCaptureID, model: model, group: group)
            
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
                        model.storage.delete(captures: [selectedCapture], model: model)
                        
                        self.selectedCaptureID = group.captures.first?._id
                        
                        debugPrint("deleted \(selectedCapture.name)")
                    }, label: {
                        Image(systemName: "trash")
                    })
                    .disabled(selectedCapture == nil)
                }

                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        guard let selectedCapture = selectedCapture else { return }
                        debugPrint("sharing all quality levels of \(selectedCapture.name)")
                        fileExportIsDisplayed = true
                    }, label: {
                        Image(systemName: "square.and.arrow.up")
                    })
                    .disabled(selectedCapture == nil)
                }

                ToolbarItem(placement: ToolbarItemPlacement.primaryAction) {
                    Button(action: {
                        importFileBrowserDisplayed = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }

            }
            
            //File Import
            .fileImporter(
                isPresented: $importFileBrowserDisplayed,
                allowedContentTypes: [UTType.folder],
                allowsMultipleSelection: false,
                onCompletion: { result in
                    do  {
                        let url = try result.get()
                        debugPrint(url)
                        if let firstUrl = url.first {
                            let capture = Capture(name: "New Model", rawUrl: firstUrl)
                            $group.captures.append(capture)
                            model.importConfigurations.append(
                                ImportConfiguration(for: capture)
                            )
                            selectedCaptureID = capture._id
                        }
                        debugPrint("file importer completion")
                    } catch {
                        debugPrint("error with importing")
                    }
                }
            )
            
            .fileExporter(
                isPresented: $fileExportIsDisplayed,
                documents: Storage.exportItems(for: selectedCapture),
                contentType: UTType.folder,
                onCompletion: { result in
                    debugPrint(result)
                })
            
            //Navigation Title / Subtitle
            .navigationTitle(selectedCapture?.name ?? "")
            .navigationSubtitle(selectedCapture?.dateCreated.formatted(date: .abbreviated, time: .shortened) ?? "")
            
            
            //present first capture on appear
            .onAppear {
                selectedCaptureID = group.captures.first?._id
            }
            
//        } else {
//            ProgressView().onAppear {
//                $captureGroups.append(CaptureGroup())
//            }
//        }
    }
}

class CaptureGroup: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var captures = RealmSwift.List<Capture>()
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let model: ContentViewModel = {
//            let realm = try! Realm()
//            let storage = Storage(with: realm)
//            return ContentViewModel(storage: storage)
//        }()
//        MainView(model: model)
//    }
//}
