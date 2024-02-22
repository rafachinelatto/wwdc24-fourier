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
    private var fourierExplanation: String =
 """
    Como estamos trabalhando em um computador, vamos estudar a transformada discreta de fourier.
    As fórmulas que regem a transfomada são as seguintes
 """
    
    private var fourierExplanation2: String =
"""
    Essas fórmulas parecem bem complicadas né. Não vou mentir, elas realmente são complicadas de se calcular, porém podemos tentar entender o que elas querem dizer!
"""
    
    private var fourierTransform = "$X_k=\\sum_{n=0}^{N-1}x_n\\cdot e^{-i2\\pi\\frac{k}{N}n}$"
    
    private var inverseTransform = "$x_n=\\frac{1}{N}\\sum_{k=0}^{N-1}X_k\\cdot e^{i2\\pi\\frac{k}{N}n}$"
    
    @State private var next: Bool = false
    
    var body: some View {
        VStack {
            Text(fourierExplanation)
                .padding()
            
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .circular)
                    .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2))
                
                VStack{
                    HStack {
                        Text("Fourier Transform:")
                            .padding(.leading)
                        Spacer()
                    }
                    LaTeX(fourierTransform)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 200)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .circular)
                    .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2))
                
                VStack{
                    HStack {
                        Text("Inverse Fourier Transform:")
                            .padding(.leading)
                        Spacer()
                    }
                    LaTeX(inverseTransform)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 200)
            
            Text(fourierExplanation2)
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
