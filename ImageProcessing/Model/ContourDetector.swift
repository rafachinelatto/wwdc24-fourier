//
//  ContourDetector.swift
//  
//
//  Created by Rafael Antonio Chinelatto on 29/01/24.
//

import Vision
import CoreImage

class ContourDetector {
    static let shared = ContourDetector()
    
    private init() {}
    
    private lazy var request: VNDetectContoursRequest = {
        let req = VNDetectContoursRequest()
        req.detectsDarkOnLight = true
        return req
    }()
    
    private var epsilon: Float = 0.001
    
    func processV2(image: CIImage?) throws -> [Contour] {
        guard let image = image else {
            print("Failed to load ciImage in contour detector")
            return []
        }
        
        let contourRequest = try performV2(request: request, on: image)
        return postProcess(request: contourRequest)
    }
    
    func performV2(request: VNRequest, on image: CIImage) throws -> VNRequest {
        let requestHandler = VNImageRequestHandler(ciImage: image, options: [:])
        try requestHandler.perform([request])
        return request
    }
    
    func process(image: CGImage?) throws -> [Contour] {
        guard let image = image else {
            print("Failed to load image")
            return []
        }
        
        let contourRequest = try perform(request: request, on: image)
        return postProcess(request: contourRequest)
    }
    
    private func perform(request: VNRequest, on image: CGImage) throws -> VNRequest {
        
        let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
        
        try requestHandler.perform([request])
        
        return request
    }
    
    private func postProcess(request: VNRequest) -> [Contour] {
        
        guard let results = request.results as? [VNContoursObservation] else {
            print("No observations found")
            return []
        }
        
//        let vnContours = results.flatMap { contour in
//            (0..<contour.contourCount).compactMap { try? contour.contour(at: $0) }
//        }
//        
        let vnContours = results.flatMap { contour in
            contour.topLevelContours 
        }
        
        let simplifiedContours = vnContours.compactMap {
            try? $0.polygonApproximation(epsilon: self.epsilon)
        }
        
        return simplifiedContours.map { Contour(vnContour: $0) }
    }
    
    func set(contrastPivot: CGFloat?) {
        request.contrastPivot = contrastPivot.map {
            NSNumber(value: $0)
        }
    }
    
    func set(contrastAdjustment: CGFloat) {
        request.contrastAdjustment = Float(contrastAdjustment)
    }
    
    func set(epsilon: CGFloat) {
        self.epsilon = Float(epsilon)
    }
}
