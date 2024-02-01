//
//  ImageProcessingViewModel.swift
//
//
//  Created by Rafael Antonio Chinelatto on 30/01/24.
//

import Vision
import SwiftUI

class ImageProcessingViewModel: ObservableObject {
    
    var inputImage: UIImage?
    @Published var outputImage: UIImage?
    @Published var contours: [Contour] = []
    @Published var calculating: Bool = false
    
    init() {}
    
    func processImage() {
        guard !calculating else { 
            print("Calculating")
            return }
        calculating = true
        print("Starting process")
        
        Task {
            guard #available(iOS 17.0, *) else { return }
            
            let ciImage = await asyncRemoveBackground()
            let contours = await asyncGetContours(ciImage: ciImage)
            
            DispatchQueue.main.async {
                self.contours = contours
                self.calculating = false
                print("Finished")
            }
        }
    }
    
    @available(iOS 17.0, *)
    func asyncRemoveBackground() async -> CIImage? {
        guard let image = inputImage else {
            print("Failed to load input image when removing background")
            return nil
        }
        
        let backgroundRemover = BackgroundRemover.shared
        do {
            let processedImage = try backgroundRemover.processV2(image: image)
            return processedImage
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    func asyncGetContours(ciImage: CIImage?) async -> [Contour] {
        
        var contours = [Contour]()
        
        let pivotStride = stride(from: 0.3, to: 0.6, by: 0.1)
        let adjustStride = stride(from: 0.4, to: 2.6, by: 0.2)

        let detector = ContourDetector.shared
        
        detector.set(epsilon: 0.001)
        
        for pivot in pivotStride {
            for adjustment in adjustStride {

                
                detector.set(contrastPivot: pivot)
                detector.set(contrastAdjustment: adjustment)
                
                let newContours = ( try? detector.processV2(image: ciImage)) ?? []
                
                contours.append(contentsOf: newContours)
            }
        }
        
        if contours.count < 9000 {
            let iouThreshold = 0.7
            
            var pos = 0
            while pos < contours.count {
                let contour = contours[pos]
                
                contours = contours[0...pos] + contours[(pos + 1)...].filter {
                    contour.intersectionOverUnion(with: $0) < iouThreshold
                }
                pos += 1
            }
        }
        return contours
    }
}