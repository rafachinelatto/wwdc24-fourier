//
//  File.swift
//  
//
//  Created by Rafael Antonio Chinelatto on 26/01/24.
//

import Vision
import UIKit
import SwiftUI
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
        

        
        let filteredOutputImage = outputImage.addFilter(filterType: .Tonal).addFilter(filterType: .NoiseReduction).addFilter(filterType: .Posterize)
        //.addFilter(filterType: .Sharpen).addFilter(filterType: .Posterize).addFilter(filterType: .Sharpen)
        return filteredOutputImage
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
}

enum FilterType : String {
    case Mono = "CIPhotoEffectMono"
    case MonoChrome = "CIColorMonochrome"
    case Noir = "CIPhotoEffectNoir"
    case Tonal = "CIPhotoEffectTonal"
    case Sharpen = "CIUnsharpMask"
    case Blur = "CIGaussianBlur"
    case Pixelate = "CIPixellate"
    case Edges = "CIEdges"
    case Negative = "CIColorInvert"
    case Posterize = "CIColorPosterize"
    case NoiseReduction = "CINoiseReduction"
    case EdgeWork = "CIEdgeWork"
    case LineOverlay = "CILineOverlay"
}

extension CIImage {
    func addFilter(filterType: FilterType) -> CIImage {
        let filter = CIFilter(name: filterType.rawValue)
        
        filter?.setValue(self, forKey: "inputImage")
        
        if filterType == .Sharpen {
            filter?.setValue(1, forKey: "inputIntensity")
            filter?.setValue(10, forKey: "inputRadius")
        }
        if filterType == .Posterize {
            filter?.setValue(3, forKey: "inputLevels")
        }
        if filterType == .MonoChrome {
            filter?.setValue(CIColor(red: 0.8, green: 0.8, blue: 0.8), forKey: "inputColor")
            filter?.setValue(1.0, forKey: "inputIntensity")
        }
        if filterType == .NoiseReduction {
            filter?.setValue(10, forKey: "inputSharpness")
            filter?.setValue(10, forKey: "inputNoiseLevel")
        }
        return (filter?.outputImage!)!
    }
}
