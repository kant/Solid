//
//  CaptureNavigationView.swift
//  Solid
//
//  Created by Andrew Sawyer on 7/6/21.
//

import SwiftUI
import RealmSwift

struct CaptureNavigationView: View {
    
    @Binding var selectedCaptureID: ObjectId?
    var selectedCapture: Capture? {
        return group.captures.first { capture in
            capture._id == selectedCaptureID
        }
    }
    @ObservedObject var model: ContentViewModel
    //@ObservedResults(Capture.self, sortDescriptor: SortDescriptor(keyPath: "dateCreated", ascending: false)) var captures
    
    //@ObservedResults(CaptureGroup.self) var captureGroups
    @ObservedRealmObject var group: CaptureGroup
    
    var body: some View {
        //Normal Sidebar and SelectedCaptureView
        
            if group.captures.count > 0 {
                NavigationView {
                    SwiftUI.List(selection: $selectedCaptureID) { //selection: $selectedCapture
                        ForEach(group.captures) { capture in
                            ModelListCell(capture: capture) //, model: model
                                .tag(capture._id)
                        }
                    }
                    //.onDeleteCommand(perform: $captures.remove)
                    .listStyle(.sidebar)
                    
                    if let selectedCapture = selectedCapture {
                        SelectedCaptureView(model: model, capture: selectedCapture)
                    } else {
                        NoCaptureSelectedView()
                    }
                }
                
            //No Captures View
            } else {
                NavigationView {
                    EmptyView()
                    NoCaptureSelectedView()
                }
            }
        }
}

