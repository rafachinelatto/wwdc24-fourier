//
//  File.swift
//  
//
//  Created by Rafael Antonio Chinelatto on 20/02/24.
//

import SwiftUI

class SquareWaveViewModel: ObservableObject {
    var circlesCenter: CGPoint = .zero
    var startX: CGFloat = .zero
    var waveWidth: CGFloat = .zero
    var amplitude: CGFloat = .zero
    var numberOfPoints: Int = .zero
    var fourierSeries: [Complex] = []
    var wave: [Complex] = []
    var drawWave: [CGPoint] = []
    var drawSquareWave: [CGPoint] = []
    var centerPoints: [CGPoint] = []
    
    @Published var epicyclePath: Path = Path()
    @Published var wavePath: Path = Path()
    @Published var linePath: Path = Path()
    @Published var squareWavePath: Path = Path()
    @Published var pointPath: Path = Path()
    @Published var centerPath: Path = Path()
    
    
    func configuration(circlesCenter: CGPoint, StartX: CGFloat, waveWidth: CGFloat, amplitude: CGFloat, numberOfPoints: Int) {
        self.circlesCenter = circlesCenter
        self.startX = StartX
        self.waveWidth = waveWidth
        self.amplitude = amplitude
        self.numberOfPoints = numberOfPoints
        generateSquareWave()
        self.fourierSeries = DFT(self.wave)
    }
    
    
    func updateWave(time: CGFloat, numberOfCircles: Int) {
        
        var epiPath = Path()
        var waPath = Path()
        var lPath = Path()
        var sqPath = Path()
        var pPath = Path()
        var cPath = Path()
        
        var newPoint = circlesCenter
        var maxCount: Int = 1
        
        if numberOfCircles >= fourierSeries.count {
            maxCount = fourierSeries.count
        } else {
            maxCount = numberOfCircles
        }
        
        for i in 0..<maxCount {
            
            epiPath.addArc(center: newPoint, radius: fourierSeries[i].mod, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360), clockwise: true)
            epiPath.move(to: newPoint)
        
            let phi = ((Double(fourierSeries[i].freq) * time)) + fourierSeries[i].phase
            
            newPoint.x += fourierSeries[i].mod * cos(phi)
            newPoint.y += fourierSeries[i].mod * sin(phi)
            
            epiPath.addLine(to: newPoint)
            epiPath.closeSubpath()
            
        }
        drawWave.insert(newPoint, at: 0)
        if drawWave.count >= numberOfPoints {
            drawWave.removeLast()
        }
        
        let step = waveWidth / Double(numberOfPoints)
        
        if drawWave.count > 0 {
            waPath.move(to: CGPoint(x: startX, y: drawWave[0].y))
            
            for i in 1..<drawWave.count {
                waPath.addLine(to: CGPoint(x: startX + step * Double(i), y: drawWave[i].y))
            }
        }
        
        if drawWave.count > 0 {
            lPath.move(to: drawWave[0])
            lPath.addLine(to: CGPoint(x: startX, y: drawWave[0].y))
        }
        
        centerPoints.insert(newPoint, at: 0)
        if centerPoints.count >= Int(Double(fourierSeries.count) * 0.2) {
            centerPoints.removeLast()
        }
        
        cPath.addLines(centerPoints)
        
        pPath.addArc(center: newPoint, radius: 4, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360), clockwise: true)
        
        self.linePath = lPath
        self.epicyclePath = epiPath
        self.wavePath = waPath
        self.pointPath = pPath
        self.centerPath = cPath
        
        for i in maxCount..<fourierSeries.count {
            let phi = ((Double(fourierSeries[i].freq) * time)) + fourierSeries[i].phase
            
            newPoint.x += fourierSeries[i].mod * cos(phi)
            newPoint.y += fourierSeries[i].mod * sin(phi)
        }
        drawSquareWave.insert(newPoint, at: 0)
        if drawSquareWave.count >= numberOfPoints {
            drawSquareWave.removeLast()
        }
        
        if drawSquareWave.count > 0 {
            sqPath.move(to: CGPoint(x: startX, y: drawSquareWave[0].y))
            
            for i in 1..<drawSquareWave.count {
                sqPath.addLine(to: CGPoint(x: startX + step * Double(i), y: drawSquareWave[i].y))
            }
        }
        
        self.squareWavePath = sqPath
    }
    
    
    func generateSquareWave() {
        let upTime = Int(Double(numberOfPoints) / 2)
        
        var count = 0
        
        for _ in 0..<numberOfPoints {
            
            count += 1
            
            if count <= upTime {
                let y = Complex(re: 0, im: amplitude)
                wave.append(y)
            }
            else if (upTime < count) && (count <= 2 * upTime) {
                let y = Complex(re: 0, im: -amplitude)
                wave.append(y)
            }
            
            if count == (2 * upTime) {
                count = 0
            }
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
