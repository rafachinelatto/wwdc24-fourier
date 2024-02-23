//
//  File.swift
//
//
//  Created by Rafael Antonio Chinelatto on 22/02/24.
//

import SwiftUI

struct SquareWaveTwoComponents: View {
    
    @ObservedObject var viewModel = SquareWaveViewModel()
    
    let timer = Timer.publish(every: 0.005, on: .main, in: .common).autoconnect()
    @State var time: Double = 0
    
    @State var numberOfCircles: Int = 2
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                
                Button(numberOfCircles == 4 ? "Remove components" : "Add components") {
                    
                    if numberOfCircles == 2 {
                        numberOfCircles = 4
                    }
                    
                    else {
                        numberOfCircles = 2
                    }
                    
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                ZStack {
                    viewModel.epicyclePath.stroke(lineWidth: 1)
                    viewModel.linePath.stroke(.red, lineWidth: 1)
                    viewModel.wavePath.stroke(Color.accentColor, lineWidth: 2)
                    viewModel.squareWavePath.stroke(Color.secondary, lineWidth: 2)
                }
            }
            .onAppear {
                viewModel.configuration(circlesCenter: CGPoint(x: geometry.size.width * 0.2, y: geometry.size.height * 0.5), StartX: geometry.size.width * 0.4, waveWidth: geometry.size.width * 0.6, amplitude: geometry.size.height * 0.3, numberOfPoints: 1000)
            }
        }
        .onReceive(timer, perform: { _ in
            let dt: Double = (2 * Double.pi) / Double(viewModel.fourierSeries.count)
            time += dt
            if time >= 2 * Double.pi {
                time = 0
            }
            viewModel.updateWave(time: time, numberOfCircles: numberOfCircles)
        })
    }
}

#Preview {
    SquareWaveTwoComponents()
}
