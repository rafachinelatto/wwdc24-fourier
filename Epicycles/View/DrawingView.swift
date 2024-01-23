import SwiftUI

struct DrawingView: View {
    
    var complexPoints: [Complex]
    var center: CGPoint = .zero
    @State var time: Double = 0
    @State var numberOfCircles = 2
    let timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()
    
    @ObservedObject var viewModel = DrawingViewModel()
    
    var body: some View {
        VStack {
            Stepper("Número de círculos: \(Int(numberOfCircles))", onIncrement: {
                if (numberOfCircles >= 1 && numberOfCircles < 10) {
                    numberOfCircles += 1
                } else if (numberOfCircles >= 10 && numberOfCircles < 100) {
                    numberOfCircles += 10
                } else if (numberOfCircles >= 100 && numberOfCircles < 700) {
                    numberOfCircles += 100
                }
            }, onDecrement: {
                if (numberOfCircles > 1 && numberOfCircles <= 10) {
                    numberOfCircles -= 1
                } else if (numberOfCircles > 10 && numberOfCircles <= 100) {
                    numberOfCircles -= 10
                } else if (numberOfCircles > 100 && numberOfCircles <= 700) {
                    numberOfCircles -= 100
                }
            }).padding()
            
            ZStack {
                Path{ path in
                    
                    if viewModel.wave.count > 2 {
                        path.addLines(viewModel.wave)
                    }
                }
                .stroke(.blue, lineWidth: 3)
                
                viewModel.epiclyclePath.stroke(lineWidth: 1)
                
            }.onReceive(timer, perform: { _ in
                let dt: Double = (2 * Double.pi) / Double(viewModel.fourierSeries.count)
                time += dt
                viewModel.updateWave(time: time, numberOfCircles: numberOfCircles)
            })
        }
        .padding()
        .task {
           // await viewModel.configuration(center: center, complexPoints: complexPoints)
        }
    }
}

