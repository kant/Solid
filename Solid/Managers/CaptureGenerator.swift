//
//  CaptureGenerator.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/27/21.
//

import Foundation
import SwiftUI
import RealmSwift
import RealityFoundation

class CaptureGenerator: Equatable {
    
    @ObservedObject private var model: ContentViewModel
    @ObservedRealmObject var capture: Capture
    var config: ImportConfiguration
    
    var session: PhotogrammetrySession?
    
    init(for capture: Capture, with config: ImportConfiguration, model: ContentViewModel) {
        self.capture = capture
        self.config = config
        self.model = model
        process()
    }
    
    func process() {
        debugPrint("begin processing with options")
            
        do {
            session = try PhotogrammetrySession(
                input: URL(fileURLWithPath: config.relativePath,
                           isDirectory: true),
                configuration: PhotogrammetrySession.Configuration()
            )
        } catch {
            debugPrint("error initializing PhotogrammetrySession")
        }
        
        guard let session = session else { return }

        
        var requests: [PhotogrammetrySession.Request] = []
        for selection in config.qualitySelections {
            requests.append(
                PhotogrammetrySession.Request.modelFile(
                    url: Storage.url(for: selection),
                    detail: selection.quality
                )
            )
        }
        
        do {
            subscribe(with: session)
            try session.process(requests: requests)
        } catch {
            debugPrint("failed to process session")
        }
        
    }
    
    func subscribe(with session: PhotogrammetrySession) {
        session.output
            .receive(on: DispatchQueue.global())
            .sink(receiveCompletion: { completion in
                var maybeError: Error? = nil
                if case .failure(let error) = completion {
                    // Handle error.
                    
                }
            }, receiveValue: { output in
                switch output {
                case .processingComplete:
                    // RealityKit has processed all requests.
                    debugPrint("RealityKit has processed all requests.")
                case let .requestComplete(request, result):
                    // RealityKit has finished processing a request.
                    debugPrint("RealityKit has finished processing a request.")
                case .inputComplete:
                    // Ingestion of images complete, processing begins.
                    debugPrint("Ingestion of images complete, processing begins.")
                case let .requestProgress(request, fractionComplete):
                    // Periodic progress update. Update UI here.
                    debugPrint("Periodic progress update. Update UI here. \(fractionComplete)")
                case let .requestError(request, error):
                    // Request encountered an error.
                    debugPrint("Request encountered an error. \(error)")
                case .processingCancelled:
                    // Processing was canceled.
                    debugPrint("Processing was canceled.")
                case let .invalidSample(id, reason):
                    // RealityKit deemed a sample invalid and didn't use it.
                    debugPrint("RealityKit deemed a sample invalid and didn't use it. \(reason)")
                case let .skippedSample(id):
                    // RealityKit was unable to use a provided sample.
                    debugPrint("RealityKit was unable to use a provided sample.")
                case .automaticDownsampling:
                    // RealityKit downsampled the input images because of resource constraints.
                    debugPrint("RealityKit downsampled the input images because of resource constraints.")
                }
            })
            .store(in: &model.captureGeneratorSubscriptions)
    }
    
    func complete() {
//        objectWillChange.send()
//        do {
//            try model.storage.realm.write {
//                if let thawedCapture = capture.thaw() {
//                    thawedCapture.isInPreviewState = false
//                }
//            }
//        } catch {
//            debugPrint("problem")
//        }
        
        model.captureGenerators.removeAll { captureGenerator in
            captureGenerator == self
        }
    }
    
    static func == (lhs: CaptureGenerator, rhs: CaptureGenerator) -> Bool {
        lhs.capture == rhs.capture && lhs.config == rhs.config
    }
}
