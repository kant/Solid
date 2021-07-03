//
//  Defaults.swift
//  Solid
//
//  Created by Andrew Sawyer on 7/2/21.
//

import Foundation

struct Defaults {
    
    static var lightingEnviroment = LightingEnviroment.styleOne
    static var wantsDOF = false
    static var focusDistance = 2.0
    static var enviromentRotation = 0.0
    static var enviromentBrightness = 1.0
    
    static var zMin = Defaults.minFocusDistance - 0.1
    static var minFocusDistance = 0.2
    static var maxFocusDistance = 3.0
}
