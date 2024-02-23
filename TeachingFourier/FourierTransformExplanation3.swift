//
//  FourierTransformExplanation3.swift
//
//
//  Created by Rafael Antonio Chinelatto on 22/02/24.
//

import SwiftUI

struct FourierTransformExplanation3: View {
    
    private var title: String = "Square Wave II"
    
    private var text01: String =
"""
    We can notice that by adding more components of the transform, our wave starts to approach more closely the initial square wave

        So let's add more to see what happens!
"""
    
    private var text02: String =
"""
    The more components (circles) we add, the closer we get to the original square wave.

    And it works not just with square waves, but with any kind of signal!
"""
    
    @State var next: Bool = false
    
    var body: some View {
        VStack {
            Text(text01)
                .padding()
            
            SquareWaveView()
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.2)
                .padding()
            
            Spacer()
            
            Text(text02)
                .padding()
            
            Spacer()
            
            Button("Continue") {
                next = true
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .navigationDestination(isPresented: $next) {
                FourierView()
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .navigationTitle(title)
    }
}


#Preview {
    FourierTransformExplanation3()
}
