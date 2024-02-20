//
//  FirstScreen.swift
//
//
//  Created by Rafael Antonio Chinelatto on 15/02/24.
//

import SwiftUI

struct FirstScreen: View {
    
    private var title: String = "Fourier Transform"
    private var fourierExplanation: String = "A transformada de Fourier pega uma onda e a transforma em uma soma de ondas senoidais com diferentes frequências"
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(fourierExplanation)
                    .padding()
                
                SquareWaveView()
                    .frame(maxWidth: .infinity, maxHeight: 300)
            }
            .navigationTitle(title)
        }
    }
}

#Preview {
    FirstScreen()
}
