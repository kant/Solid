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
        showProgressBar()
        
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
            guard selection.selected else { continue }
            requests.append(
                PhotogrammetrySession.Request.modelFile(
                    url: Storage.url(for: capture, with: selection.quality),
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
    
    //1
    //self.model.currentlyProcessingProgress = fractionComplete
    
    
    //2
//    debugPrint("RealityKit has finished processing a request.")
//    debugPrint("& has saved to \(url)")
//
//    let processedFile = ProcessedFile()
//    processedFile.quality = quality
//    capture.processedFiles.append(processedFile)
    
    func subscribe(with session: PhotogrammetrySession) {
        async {
            for try await output in session.outputs {
                switch output {
                    
                case .inputComplete:
                    debugPrint("input complete")
                case .requestError(_, _):
                    debugPrint("request error")
                case let .requestComplete(.modelFile(url: _, detail: quality, geometry: nil), .modelFile(saveUrl)):
                    debugPrint("RealityKit has finished processing a request.")
                    debugPrint("& has saved to \(saveUrl)")
                    
                    model.storage.new(ProcessedFile(quality: quality), for: capture)
                    
                case .requestProgress(_, fractionComplete: let fractionComplete):
                    debugPrint("progress update: \(fractionComplete)")
                    self.model.currentlyProcessingProgress = fractionComplete
                case .processingComplete:
                    debugPrint("processing complete")
                    //hide progress bar?
                case .processingCancelled:
                    debugPrint("processing cancelled")
                case .invalidSample(id: let id, reason: let reason):
                    debugPrint("invalid sample \(id) \(reason)")
                case .skippedSample(id: let id):
                    debugPrint("skipped sample \(id)")
                case .automaticDownsampling:
                    debugPrint("automatic down sampling")
                @unknown default:
                    debugPrint("PhotogrammetrySession.Outputs default")
                }
            }
        }
    }

    private func showProgressBar() {
        do {
            try model.storage.realm.write {
                if let thawedCapture = capture.thaw() {
                    thawedCapture.isInPreviewState = false
                }
            }
        } catch {
            debugPrint("couldn't write to realm while updating preview state")
        }
    }
    
    func complete() {

        model.captureGenerators.removeAll { captureGenerator in
            captureGenerator == self
        }
    }
    
    static func == (lhs: CaptureGenerator, rhs: CaptureGenerator) -> Bool {
        lhs.capture == rhs.capture && lhs.config == rhs.config
    }
}
