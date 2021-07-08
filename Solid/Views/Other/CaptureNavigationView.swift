//
//  CaptureNavigationView.swift
//  Solid
//
//  Created by Andrew Sawyer on 7/6/21.
//

import SwiftUI
import RealmSwift

struct CaptureNavigationView: View {
    
    @Binding var selectedCapture: Capture?
    @ObservedObject var model: ContentViewModel
    @ObservedResults(Capture.self, sortDescriptor: SortDescriptor(keyPath: "dateCreated", ascending: false)) var captures
    
    var body: some View {
        //Normal Sidebar and SelectedCaptureView
        if captures.count > 0 {
            NavigationView {
                SwiftUI.List(selection: $selectedCapture) {
                    ForEach(captures) { capture in
//                        NavigationLink {
//                            SelectedCaptureView(model: model, capture: capture)
//                        } label: {
                            ModelListCell(capture: capture)
                                .tag(capture)
                    }
                }
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
