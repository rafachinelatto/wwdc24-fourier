//
//  FourierView.swift
//
//
//  Created by Rafael Antonio Chinelatto on 23/01/24.
//

import SwiftUI

struct FourierView: View {
    
    @ObservedObject private var viewModel = DrawingViewModel()
    
    @State private var time: Double  = 0
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    @State private var numberOfCircles = 2
    @State private var showFourier: Bool = false
    @State private var complexPoints: [Complex] = []
    
    @State private var canvasSize: CGSize = .zero
    @State private var canvasRect: CGRect = .zero
    @State private var center: CGPoint?
    
    @State private var finishedDrawing: Bool = false
    @State private var points: [CGPoint] = []
    
    
    var body: some View {
        
        ZStack {
            if points.isEmpty {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("Draw Something")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    Spacer()
                }
            }
            
            VStack {
                
                VStack {
                    
                    
                    Canvas { contex, size in
                        
                        if showFourier == false {
                            
                            var path = Path()
                            path.addLines(points)
                            path.addLine(to: points.first ?? .zero)
                            contex.stroke(path, with: .color(.accentColor), style: StrokeStyle(lineWidth: 4))
                            
                        }
                        
                        else {
                            var path = Path()
                            path.addLines(points)
                            contex.stroke(path, with: .color(.secondary), style: StrokeStyle(lineWidth: 3))
                            
                            var wavePath = Path()
                            if viewModel.wave.count > 2 {
                                wavePath.addLines(viewModel.wave)
                            }
                            contex.stroke(wavePath, with: .color(.accentColor), style: StrokeStyle(lineWidth: 4))
                            
                            contex.stroke(viewModel.epiclyclePath, with: .color(.secondary), style: StrokeStyle(lineWidth: 0.5))
                            contex.stroke(viewModel.linesPath, with: .color(.yellow), style: StrokeStyle(lineWidth: 0.7))
                            contex.fill(viewModel.circlePath, with: .color(.red))
                            
                        }
                        
                    }.background() {
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    canvasSize = geometry.size
                                    canvasRect = geometry.frame(in: .local)
                                    center = CGPoint(x: geometry.size.width/2, y: geometry.size.height/2)
                                    print(canvasSize)
                                }
                            
                        }
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged{ value in
                                if finishedDrawing == false {
                                    
                                    let newPoint = value.location
                                    
                                    if canvasRect.contains(newPoint) {
                                        points.append(newPoint)
                                    }
                                    
                                    let complexPoint = Complex(re: (-canvasSize.width/2 + newPoint.x), im: (-canvasSize.height/2 + newPoint.y))
                                    complexPoints.append(complexPoint)
                                }
                            }
                            .onEnded { value in
                                if let point = points.first {
                                    points.append(point)
                                }
                                finishedDrawing = true
                            }
                    )
                }
                
                HStack {
                    
                    if showFourier == false {
                        
                        Button("Apply Fourier Transform") {
                            viewModel.configuration(center: center ?? .zero, complexPoints: complexPoints)
                            showFourier = true
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!finishedDrawing)
                        
                        
                    } else {
                        Stepper("Number of terms: \(Int(numberOfCircles))", onIncrement: {
                            if (numberOfCircles >= 1 && numberOfCircles < 10) {
                                numberOfCircles += 1
                            } else if (numberOfCircles >= 10 && numberOfCircles < 100) {
                                numberOfCircles += 10
                            } else if (numberOfCircles >= 100 && numberOfCircles < 1000) {
                                numberOfCircles += 100
                            }
                        }, onDecrement: {
                            if (numberOfCircles > 1 && numberOfCircles <= 10) {
                                numberOfCircles -= 1
                            } else if (numberOfCircles > 10 && numberOfCircles <= 100) {
                                numberOfCircles -= 10
                            } else if (numberOfCircles > 100 && numberOfCircles <= 1000) {
                                numberOfCircles -= 100
                            }
                        })
                        .padding(.horizontal)
                        .onChange(of: numberOfCircles) { newValue in
                            viewModel.resetDrawing()
                        }
                        
                        
                    }
                }
                .padding(.bottom)
                .onReceive(timer) { _ in
                    let dt: Double = (2 * Double.pi) / Double(viewModel.fourierSeries.count)
                    if showFourier == false {
                        time = 0
                    } else {
                        time += dt
                        viewModel.updateWave(time: time, numberOfCircles: numberOfCircles)
                    }
                }
                .toolbar {
                    
                    Button("Redraw") {
                        points.removeAll()
                        complexPoints.removeAll()
                        viewModel.reset()
                        finishedDrawing = false
                        showFourier = false
                        numberOfCircles = 2
                    }
                }
                .navigationTitle("Fourier Drawing")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
}
