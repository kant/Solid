//
//  Storage.swift
//  Solid
//
//  Created by Andrew Sawyer on 6/19/21.
//

import Foundation
import SwiftUI
import RealmSwift
import RealityFoundation

class Storage {
    var realm: Realm
    
    init(with realm: Realm) {
        self.realm = realm
    }
    
    func newCapture(with folderUrl: URL) {
        let capture = Capture(name: "New Model", rawUrl: folderUrl)
        do {
            try realm.write {
                realm.add(capture)
            }
        } catch {
            debugPrint("could not add new capture")
        }
    }
    
    func new(_ processedFile: ProcessedFile, for capture: Capture) {
        do {
            try realm.write {
                if let thawedCapture = capture.thaw() {
                    thawedCapture.processedFiles.append(processedFile)
                }
            }
        } catch {
            debugPrint("couldn't add new processed file")
        }
    }
    
    func delete(captures: [Capture], model: ContentViewModel? = nil) {
        debugPrint("deleting \(captures.count) captures")
       
        var thawedCaptures: [Capture] = []
        
        for capture in captures {
            if let model = model {
                stopProcessing(for: capture, with: model)
            }
            Storage.deleteFiles(for: capture)
            
            if let thawed = capture.thaw() {
                thawedCaptures.append(thawed)
            }
        }
        
        do {
            try realm.write {
                realm.delete(thawedCaptures)
            }
        } catch {
            debugPrint("couldn't add new processed file")
        }
    }
    
    private static func deleteFiles(for capture: Capture) {
        for processedFile in capture.processedFiles {
            let url = Storage.url(for: capture, with: processedFile.quality)
            try? FileManager.default.removeItem(at: url)
        }
    }
    
    private func stopProcessing(for capture: Capture, with model: ContentViewModel) {
        for captureGenerator in model.captureGenerators {
            if
                captureGenerator.capture == capture,
                let index = model.captureGenerators.firstIndex(of: captureGenerator) {
                
                captureGenerator.session?.cancel()
                model.captureGenerators.remove(at: index)
                
                break
            }
        }
    }
    
    static private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func url(for capture: Capture, with quality: PhotogrammetrySession.Request.Detail) -> URL {
        return getDocumentsDirectory().appendingPathComponent("\(capture.id)_\(quality.name).usdz")
    }
    
    static func fileExists(at url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }
}
