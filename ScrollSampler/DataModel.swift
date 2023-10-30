//
//  DataModel.swift
//  ScrollSampler
//
//  Created by HubertMac on 30/10/2023.
//

import Foundation
import SwiftUI


@Observable
class DataModel {
    var topLeading = TransitionVariant(id: "Top Leading")
    var bottomTrailing = TransitionVariant(id: "BottomTrailing")
    var identity = TransitionVariant(id: "Identity")
    
    var variants: [TransitionVariant] {
        [topLeading, identity, bottomTrailing]
    }
    
    func callAsFunction(_ keyPath: KeyPath<TransitionVariant, Double>, for phase:
             ScrollTransitionPhase) -> Double {
        switch phase {
        case .topLeading:
            topLeading[keyPath: keyPath]
        case .identity:
            identity[keyPath: keyPath]
        case .bottomTrailing:
            bottomTrailing[keyPath: keyPath]
        }
    }
    
}


@Observable
class TransitionVariant: Identifiable {
    var id: String
    var opacity = 1.0
    var scale = 1.0
    var xOffset = 0.0
    var yOffset = 0.0
    var blur = 0.0
    var saturation = 1.0
    var degrees = 0.0
    var rotationX = 0.0
    var rotationY = 0.0
    var rotationZ = 0.0
    
    init(id: String) {
        self.id = id
        
    }
}
