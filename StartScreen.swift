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
    Rafael is a student at the Apple Developer Academy in Campinas, as well as a student of electrical engineering at the State University of Campinas.
"""
    
    private var learn: String =
"""
    This app was made to demonstrate what the Fourier transform is and discover some cool things that can be done with it.
"""
    
    private var fourierExplanation: String =
"""
    The Fourier Transform is a tool that breaks down signals into their basic building blocks or frequencies. It helps us understand and analyze waves in terms of the different pitches or tones they contain.
    It plays a crucial role in telecommunications, image processing, and medicine, making it indispensable for understanding wave patterns.
"""
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                HStack {
                    
                    Image(systemName: "person")
                        .font(.title)
                        .foregroundStyle(Color.accentColor)
                        .padding(.trailing, 5)
                    
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
