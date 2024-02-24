//
//  EpicyclesOnlyView.swift
//
//
//  Created by Rafael Antonio Chinelatto on 24/02/24.
//

import SwiftUI

struct EpicyclesOnlyView: View {
    
    @ObservedObject var viewModel = SquareWaveViewModel()
    
    let timer = Timer.publish(every: 0.005, on: .main, in: .common).autoconnect()
    @State var time: Double = 0
    
    var numberOfCircles: Int = 10
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                viewModel.epicyclePath.stroke(lineWidth: 1)
                viewModel.pointPath.fill(.red)
                viewModel.centerPath.stroke(Color.accentColor, lineWidth: 4)
                
            }
            .onAppear {
                viewModel.configuration(circlesCenter: CGPoint(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5), StartX: .zero, waveWidth: .zero, amplitude: geometry.size.height * 0.3, numberOfPoints: 1000)
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
    EpicyclesOnlyView()
}
