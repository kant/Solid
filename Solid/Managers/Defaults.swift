//
//  Defaults.swift
//  Solid
//
//  Created by Andrew Sawyer on 7/2/21.
//

import Foundation

struct Defaults {
    
    static var lightingEnvironment = LightingEnvironment.styleOne
    static var isBackgroundVisible = true
    
    static var wantsDOF = false
    static var focusDistance = 2.0
    static var environmentRotation = 0.0
    
    static var zMin = Defaults.minFocusDistance - 0.1
    static var minFocusDistance = 0.2
    static var maxFocusDistance = 3.0
}
