//
//  FourierTransformExplanation2.swift
//
//
//  Created by Rafael Antonio Chinelatto on 21/02/24.
//

import SwiftUI

struct FourierTransformExplanation2: View {
    
    private var title: String = "Square Wave"
    
    private var squareWaveIntroduction: String =
"""
    Para tentar vizualizar essa transformada de fourier, vamos aplicá-la a uma onda quadrada.

    Ao aplicar a trasformada em uma onda quadrada, conseguimos desenhar a onda quadrada usando uma soma se senos com frequencias e fases variadas. 

    Podemos vizualizar isso da seguinte forma, onde cada círculo é um dos coeficientes da serie de Fourier da onda quadrada.
"""
    
    private var continueText: String = 
"""
    Vimos o que acontece ao aplicar a transformada de fourier em uma onda de um dimensão, pórem podemos estender está transformada para duas dimensões e assim aplicá-la a um desenho
"""
    
    @State private var next: Bool = false
    
    var body: some View {
        
        VStack {
            
            Text(squareWaveIntroduction)
                .padding()
            
            SquareWaveView()
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.3)
                .padding(.leading, 40)
            
            Spacer()
            
            Button("Let's Draw") {
                next = true
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .navigationDestination(isPresented: $next) {
                FourierView()
                    .navigationBarBackButtonHidden()
            }
            
        }.navigationTitle(title)
        
    }
}


#Preview {
    FourierTransformExplanation2()
}
