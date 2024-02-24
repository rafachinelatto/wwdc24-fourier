//
//  FourierTransformExplanation2.swift
//
//
//  Created by Rafael Antonio Chinelatto on 21/02/24.
//

import SwiftUI

struct FourierTransformExplanation2: View {
    
    private var title: String = "Square Wave Transform"
    
    private var text01: String =
"""
    First, let's apply the Fourrier Transform to the following square wave, and we will vizualize the result.
"""

    private var text02: String =
"""
    The result of the transform is a series of terms where each term can be represented by a rotating circle and, when we add the terms, it aproximates the original wave.

    Here, you can see the result and add more terms to see what happens:
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
                .padding(.horizontal)
            
            
            SquareWaveView()
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.25)
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
            
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}


#Preview {
    FourierTransformExplanation2()
}
