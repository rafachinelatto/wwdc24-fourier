//
//  FourierTransformExplçanation1.swift
//
//
//  Created by Rafael Antonio Chinelatto on 15/02/24.
//

import SwiftUI
import LaTeXSwiftUI

struct FourierTransformExplanation1: View {
    
    private var title: String = "Fourier Transform"
    
    private var text01: String =
"""
    To understand Fourier Transform, see it as a signal conductor, like in a music orchestra. It breaks down complex waves into individual frequencies, each acting as an instrument.

    To break the signal into individual frequencies, we use the following formula:
"""
    
    private var text02: String =
"""
    In this formula, $x_{n}$ represents the signal, and $X_{k}$ is the transform, both being sequences.

    This formula might be a bit challenging to grasp, but our computer can compute it very rapidly.

    Each term of $X_{k}$ is a complex number that, in polar coordinates, represents the phase and magnitude of a sine wave with the frequency k.
"""
    
    private var fourierTransform = "$X_k=\\sum_{n=0}^{N-1}x_n\\cdot e^{-i2\\pi\\frac{k}{N}n}$"
    
    private var inverseTransform = "$x_n=\\frac{1}{N}\\sum_{k=0}^{N-1}X_k\\cdot e^{i2\\pi\\frac{k}{N}n}$"
    
    @State private var next: Bool = false
    
    var body: some View {
        VStack {
            Text(text01)
                .padding()
            
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .circular)
                    .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2))
                
                VStack {
                    HStack {
                        Text("Fourier Transform:")
                            .italic()
                            .bold()
                            .padding(.leading)
                        Spacer()
                    }
                    LaTeX(fourierTransform)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 150)
            
            LaTeX(text02)
                .padding()
            
            Button("Continue") {
                next = true
            }
            .buttonStyle(.borderedProminent)
            .navigationDestination(isPresented: $next) {
                FourierTransformExplanation2()
            }
        }
        .navigationTitle(title)
        
    }
}

#Preview {
    FourierTransformExplanation1()
}
