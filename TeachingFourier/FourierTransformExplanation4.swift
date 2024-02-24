//
//  FourierTransformExplanation4.swift
//
//
//  Created by Rafael Antonio Chinelatto on 24/02/24.
//

import SwiftUI

struct FourierTransformExplanation3: View {
    
    private var title: String = "Can we Draw?"
   
    private var text01: String =
"""
    We can see that the more components we have in the sum, the closer it gets to the original wave.

    But that's not all, let's take a closer look at the circles that are generating the wave:
"""
    
    private var text02: String =
"""
    You can observe that the red point traces a line, and when projected to the side, it forms the wave we saw.

    This occurs because the transform initially processes a signal of real numbers (our square wave). Yet, it can also handle complex input, featuring both real and imaginary parts.

    This implies that we can input a 2D closed path, using the real components as the x-axis and the imaginary components as the y-axis, wich is a drawing.

    With this capability, we can transform that line into a drawing. Shall we give it a try?
"""
    
    @State private var next: Bool = false
    
    var body: some View {
        VStack {
            Text(text01)
                .padding(.horizontal)
                .padding(.top)
            
            EpicyclesOnlyView()
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.15)
            
            Spacer()
            
            Text(text02)
                .padding(.horizontal)
            
            Spacer()
            
            Button("Let's Draw!") {
                next = true
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .navigationDestination(isPresented: $next) {
                FourierView()
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    FourierTransformExplanation3()
}
