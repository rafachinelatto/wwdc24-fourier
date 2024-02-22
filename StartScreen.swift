//
//  FirstScreenDemo().swift
//  
//
//  Created by Rafael Antonio Chinelatto on 23/01/24.
//

import Foundation
import SwiftUI


struct StartScreen: View {
    @State private var start: Bool = false
    
    private var aboutMe: String =
"""
    Rafael é um estudante na Apple Developer Academy de Campinas, além de ser estudade de engenharia elétrica na Unicamp.
"""
    
    private var learn: String =
"""
    Este app foi feito para mostrar o que é a transformada de fourier e descobrir algumas coisas legais que podem ser feitas com ela.
"""
    
    private var fourierExplanation: String =
"""
    A transformada de fourier é utilizada para separar um sinal qualquer em uma soma de ondas senoidais de frequências diferentes. Ela é útil em diversas áreas que envolvem processamento de sinais.
"""
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                HStack {
                    
                    Image(systemName: "person")
                        .font(.title)
                        .foregroundStyle(Color.accentColor)
                    
                    VStack {
                        HStack {
                            Text("About the author")
                                .bold()
                                .font(.title3)
                            Spacer()
                        }
                        Text(aboutMe)
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                    }
                    Spacer()
                }
                .padding()
                
                HStack {
                    
                    Image(systemName: "book")
                        .font(.title)
                        .foregroundStyle(Color.accentColor)
                    
                    VStack {
                        HStack {
                            Text("Learning")
                                .bold()
                                .font(.title3)
                            Spacer()
                        }
                        Text(learn)
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                    }
                    Spacer()
                }
                .padding()
                
                HStack {
                    
                    Image(systemName: "alternatingcurrent")
                        .font(.title)
                        .foregroundStyle(Color.accentColor)
                    
                    VStack {
                        HStack {
                            Text("Fourier Transform")
                                .bold()
                                .font(.title3)
                            Spacer()
                        }
                        Text(fourierExplanation)
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                    }
                    Spacer()
                }
                .padding()
                
                Spacer()
                Spacer()
                Button("Let's Learn") {
                    start = true
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .navigationDestination(isPresented: $start) {
                    FourierTransformExplanation1()
                        
                }
            }
            .navigationTitle("Fourier Drawing")
        }
    }
}


#Preview {
    StartScreen()
}
