//
//  EpicylclesViewModel.swift
//  wwdc
//
//  Created by Rafael Antonio Chinelatto on 18/01/24.
//

import Foundation
import SwiftUI

class DrawingViewModel: ObservableObject {
    
    var center: CGPoint = .zero
    var fourierSeries: [Complex] = []
    @Published var epiclyclePath: Path = Path()
    @Published var linesPath: Path = Path()
    @Published var circlePath: Path = Path()
    @Published var wave: [CGPoint] = []
    
    init(center: CGPoint = .zero, fourierSeries: [Complex] = [], wave: [CGPoint] = [], epicyclePath: Path = Path()) {
        self.center = center
        self.wave = wave
        self.epiclyclePath = epicyclePath
    }
    
    func configuration(center: CGPoint, complexPoints: [Complex]) {
        self.center = center
        self.fourierSeries = self.DFT(complexPoints)
    }
    
    func reset() {
        self.fourierSeries.removeAll()
        self.wave.removeAll()
        self.epiclyclePath = Path()
    }
    
    func resetDrawing() {
        self.wave.removeAll()
    }

    func updateWave(time: CGFloat, numberOfCircles: Int) {
        
        var newPoint: CGPoint = center
        var epiPath = Path()
        var lPath = Path()
        var cPath = Path()
        var maxCount: Int = 1
        
        if numberOfCircles >= fourierSeries.count {
            maxCount = fourierSeries.count
        } else {
            maxCount = numberOfCircles
        }
        
        
        for i in 0..<maxCount {
        
            epiPath.addArc(center: newPoint, radius: fourierSeries[i].mod, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360), clockwise: true)
            epiPath.move(to: newPoint)
            lPath.move(to: newPoint)
            
            let phi = ((Double(fourierSeries[i].freq) * time)) + fourierSeries[i].phase
            
            newPoint.x += fourierSeries[i].mod * cos(phi)
            newPoint.y += fourierSeries[i].mod * sin(phi)
            
            lPath.addLine(to: newPoint)
            epiPath.closeSubpath()
            lPath.closeSubpath()
        }
        
        cPath.addArc(center: newPoint, radius: 4, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360), clockwise: true)
        wave.append(newPoint)
        
        self.circlePath = cPath
        self.epiclyclePath = epiPath
        self.linesPath = lPath
        
        if wave.count >= Int(Double(fourierSeries.count) * 0.95) {
            wave.removeFirst()
        }
    }
    
    func DFT(_ x:[Complex]) -> [Complex] {
        
        var X = [Complex]()
        let N = x.count
        
        for k in 0..<N {
            var Xk = Complex(re: 0, im: 0, freq: k)
            
            for n in 0..<N {
                let aux = Complex(re: cos((2*Double.pi*Double(k*n))/Double(N)), im: -sin((2*Double.pi*Double(k*n))/Double(N)))
                
                Xk = Xk + (x[n] * aux)
            }
            
            Xk = Xk * Complex(re: 1/Double(N), im: 0)
            X.append(Xk)
        }
        
        let XSorted = X.sorted{ $0.mod > $1.mod }
        return XSorted
    }
}
