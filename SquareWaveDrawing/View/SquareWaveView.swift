//
//  SquareWaveView.swift
//
//
//  Created by Rafael Antonio Chinelatto on 20/02/24.
//

import SwiftUI

struct SquareWaveView: View {
    
    @ObservedObject var viewModel = SquareWaveViewModel()
    
    let timer = Timer.publish(every: 0.005, on: .main, in: .common).autoconnect()
    @State var time: Double = 0
    
    @State var numberOfCircles: Int = 2
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                Stepper("Number of circles: \(numberOfCircles)") {
                    numberOfCircles += 2
                } onDecrement: {
                    if numberOfCircles > 2 {
                        numberOfCircles -= 2
                    }
                }
                .padding()
                
                
                ZStack {
                    viewModel.epicyclePath.stroke(lineWidth: 1)
                    viewModel.linePath.stroke(.red, lineWidth: 1)
                    viewModel.wavePath.stroke(.blue, lineWidth: 2)
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
    SquareWaveView()
}
