//
//  File.swift
//  
//
//  Created by Bijoy  Debnath on 1/10/23.
//

import Foundation
import SwiftUI

public struct FirstAppear: ViewModifier {
    let action: () -> ()
    
    // Use this to only fire your block one time
    @State private var hasAppeared = false
    
    public func body(content: Content) -> some View {
        // And then, track it here
        content.onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            action()
        }
    }
}
