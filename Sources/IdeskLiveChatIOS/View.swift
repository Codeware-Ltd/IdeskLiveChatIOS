//
//  File.swift
//  
//
//  Created by Bijoy  Debnath on 1/10/23.
//

import Foundation
import SwiftUI

public extension View {
    func onFirstAppear(_ action: @escaping () -> ()) -> some View {
        modifier(FirstAppear(action: action))
    }
    
     func alertPatched(isPresented: Binding<Bool>, content: () -> Alert) -> some View {
          self.overlay(
              EmptyView().alert(isPresented: isPresented, content: content),
              alignment: .bottomTrailing
          )
      }
}
