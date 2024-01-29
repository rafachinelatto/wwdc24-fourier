//
//  ContourDetector.swift
//  
//
//  Created by Rafael Antonio Chinelatto on 29/01/24.
//

import Vision

class ContourDetector {
    static let shared = ContourDetector()
    
    private init() {}
    
    private lazy var request: VNDetectContoursRequest = {
        let req = VNDetectContoursRequest()
        return req
    }()
    
    
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
        
        let vnContours = results.flatMap { contour in
            (0..<contour.contourCount).compactMap { try? contour.contour(at: $0) }
        }
        
        return vnContours.map { Contour(vnContour: $0) }
    }
}
