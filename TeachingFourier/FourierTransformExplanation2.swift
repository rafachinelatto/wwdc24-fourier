//
//  FourierTransformExplanation2.swift
//
//
//  Created by Rafael Antonio Chinelatto on 21/02/24.
//

import SwiftUI

struct FourierTransformExplanation2: View {
    
    private var title: String = "Square Wave I"
    
    private var text01: String =
"""
    Let's apply the Fourier Transform we just saw to a square wave to understand how it works.

    This is a square wave:
"""
    
    private var text02: String =
"""
    Applying the fourier transform we get a series of sine waves, to represent this sine waves we can use rotating circles.

    Let's visualize the first four components of the series.
"""
    
    @State private var next: Bool = false
    
    var body: some View {
        
        VStack {
            
            Text(text01)
                .padding()
            
            GeometryReader { geometry in
                
                Path { path in
                    
                    path.move(to: CGPoint(x: .zero, y: geometry.size.height))
                    path.addLine(to: CGPoint(x: geometry.size.width * 0.25, y: geometry.size.height))
                    path.addLine(to: CGPoint(x: geometry.size.width * 0.25, y: .zero))
                    path.addLine(to: CGPoint(x: geometry.size.width * 0.75, y: .zero))
                    path.addLine(to: CGPoint(x: geometry.size.width * 0.75, y: geometry.size.height))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                    
                }.stroke(Color.accentColor, lineWidth: 2)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.10)
            
            //            SquareWaveView()
            //                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.3)
            //                .padding(.leading, 40)
            
            Text(text02)
                .padding()
            
            
            SquareWaveTwoComponents()
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.2)
                .padding()
            
            Spacer()
            
            Button("Continue") {
                next = true
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .navigationDestination(isPresented: $next) {
                FourierTransformExplanation3()
            }
            
        }.navigationTitle(title)
        
    }
}


#Preview {
    FourierTransformExplanation2()
}
