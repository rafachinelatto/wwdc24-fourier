//
//  ContourDetectorViewModel.swift
//
//
//  Created by Rafael Antonio Chinelatto on 29/01/24.
//

import SwiftUI
import Vision

class ContourDetectorViewModel: ObservableObject {
    
    var inputImage: UIImage?
    @Published var contours: [Contour] = []
    @Published var calculating: Bool = false
    
    init() {}
    
    
    func updateContours() {
        guard !calculating else { return }
        calculating = true
        
        guard let inputImage = inputImage else {
            print("Failed to load input image")
            return
        }
        
        let cgImage = inputImage.cgImage
        
        Task {
            let contours = await asyncUpdateContours(cgImage: cgImage)
            
            DispatchQueue.main.async {
                self.contours = contours
                self.calculating = false
            }
        }
    }
    
    
    func asyncUpdateContours(cgImage: CGImage?) async -> [Contour] {
        let detector = ContourDetector.shared
        return ( try? detector.process(image: cgImage) ) ?? []
    }
    
    
}


