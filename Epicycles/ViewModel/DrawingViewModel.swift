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
    @Published var wave: [CGPoint] = []
    
    init(center: CGPoint = .zero, fourierSeries: [Complex] = [], wave: [CGPoint] = [], epicyclePath: Path = Path()) {
        self.center = center
        self.wave = wave
        self.epiclyclePath = epicyclePath
    }
    
    @MainActor func configuration(center: CGPoint, complexPoints: [Complex]) async {
        self.center = center
        self.fourierSeries = DFT(complexPoints)
    }

    func updateWave(time: CGFloat, numberOfCircles: Int) {
        
        var newPoint: CGPoint = center
        var path = Path()
        var maxCount: Int = 1
        
        if numberOfCircles >= fourierSeries.count {
            maxCount = fourierSeries.count
        } else {
            maxCount = numberOfCircles
        }
        
        
        for i in 0..<maxCount {
        
            path.addArc(center: newPoint, radius: fourierSeries[i].mod, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360), clockwise: true)
            path.move(to: newPoint)
            
            let phi = ((Double(fourierSeries[i].freq) * time)) + fourierSeries[i].phase
            
            newPoint.x += fourierSeries[i].mod * cos(phi)
            newPoint.y += fourierSeries[i].mod * sin(phi)
            
            path.addLine(to: newPoint)
            path.closeSubpath()
        }
        
        wave.append(newPoint)
        self.epiclyclePath = path
        
        if wave.count >= (fourierSeries.count - 10) {
            wave.removeFirst()
        }
    }
}
