//
//  InputDrawing.swift
//  wwdc
//
//  Created by Rafael Antonio Chinelatto on 19/01/24.
//

import SwiftUI

struct InputDrawing: View {
    
    @State private var points: [CGPoint] = []
    @State private var complexPoints: [Complex] = []
    @State private var canvasSize: CGSize = .zero
    @State private var center: CGPoint?
    @State private var finishedDrawing: Bool = false
    @State private var goToFourier: Bool = false
    
    var body: some View {
        
        
        VStack {
            
            HStack {
                
                Button("Use this drawing") {
                    goToFourier = true
                }
                .buttonStyle(.bordered)
                .disabled(!finishedDrawing)
                
                Button("Redraw") {
                    points.removeAll()
                    complexPoints.removeAll()
                    finishedDrawing = false
                }
                .buttonStyle(.bordered)
                .disabled(!finishedDrawing)
                
            }.navigationDestination(isPresented: $goToFourier) {
                if let center = center {
                    DrawingView(complexPoints: complexPoints, center: center)
                }
                
            }
            
            
            Canvas { contex, size in
                
                var path = Path()
                path.addLines(points)
                contex.stroke(path, with: .color(.cyan), style: StrokeStyle(lineWidth: 3))
                
                //                var axis = Path()
                //                axis.move(to: CGPoint(x: 0, y: size.height/2))
                //                axis.addLine(to: CGPoint(x: size.width, y: size.height/2))
                //                axis.move(to: CGPoint(x: size.width/2, y: 0))
                //                axis.addLine(to: CGPoint(x: size.width/2, y: size.height))
                //                contex.stroke(axis, with: .color(.red), style: StrokeStyle(lineWidth: 5))
                
            }.background() {
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            canvasSize = geometry.size
                            center = CGPoint(x: geometry.size.width/2, y: geometry.size.height/2)
                        }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        
                        if finishedDrawing == false {
                            
                            let newPoint = value.location
                            points.append(newPoint)
                            
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
    }
    
}
