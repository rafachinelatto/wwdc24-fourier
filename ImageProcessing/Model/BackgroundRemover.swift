//
//  File.swift
//  
//
//  Created by Rafael Antonio Chinelatto on 26/01/24.
//

import Vision
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

@available(iOS 17.0, *)
class BackgroundRemover {
    static let shared = BackgroundRemover()
    
    private init() {}
    
    private lazy var request: VNGenerateForegroundInstanceMaskRequest = {
        let req = VNGenerateForegroundInstanceMaskRequest()
        return req
    }()
    
    func processV2(image: UIImage) throws -> CIImage? {
        guard let inputImageNoOrientation = CIImage(image: image) else {
            print("Failed to create CIImage")
            return nil
        }
        
        let orientation = image.imageOrientation
        let inputImage = inputImageNoOrientation.oriented(CGImagePropertyOrientation(orientation))
        
        
        guard let maskImage = try perform(request: request, on: inputImage) else {
            print("Failed to create mask Image")
            return nil
        }
        
        let outputImage = apply(mask: maskImage, toImage: inputImage)        
        return outputImage
    }
    
    
    func process(image: UIImage) throws -> UIImage? {
        
        guard let inputImageNoOrientation = CIImage(image: image) else {
            print("Failed to create CIImage")
            return nil
        }
        
        let orientation = image.imageOrientation
        let inputImage = inputImageNoOrientation.oriented(CGImagePropertyOrientation(orientation))
        
        
        guard let maskImage = try perform(request: request, on: inputImage) else {
            print("Failed to create mask Image")
            return nil
        }
        
        let ciOutputImage = apply(mask: maskImage, toImage: inputImage)
        let outputImage = render(ciImage: ciOutputImage)
        
        return outputImage
    }
   
    
    private func perform(request: VNRequest, on image: CIImage) throws -> CIImage? {
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        try handler.perform([request])
        
        guard let result = request.results?.first as? VNInstanceMaskObservation else {
            print("No observations found")
            return nil
        }
        
        let maskPixelBuffer = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: handler)
        
        return CIImage(cvPixelBuffer: maskPixelBuffer)
    }
    
    private func apply(mask: CIImage, toImage image: CIImage) -> CIImage {
        let filter = CIFilter.blendWithMask()
        filter.inputImage = image
        filter.maskImage = mask
        let backgroundImage = CIImage(color: CIColor.white).cropped(to: image.extent)
        filter.backgroundImage = backgroundImage
        return filter.outputImage!
    }
    
    
    private func render(ciImage: CIImage) -> UIImage {
        guard let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) else {
            fatalError("Failed to render CGImage")
        }
        return UIImage(cgImage: cgImage)
    }
}
