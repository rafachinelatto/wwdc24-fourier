//
//  File.swift
//  
//
//  Created by Rafael Antonio Chinelatto on 25/01/24.
//

import Vision
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class ImageLifitingViewModel: ObservableObject {
    
    var inputImage: UIImage?
    @Published var outputImage: UIImage?
    @Published var calculating: Bool = false
    
    init() {}
    
    func removeBackground() {
        guard !calculating else { return }
        calculating = true
        
        Task {
            
            if #available(iOS 17.0, *) {
                let image = await asyncRemoveBackground()
                
                DispatchQueue.main.async {
                    self.outputImage = image
                    self.calculating = false
                }
            } else {
                return
            }
        }
    }
    
    @available(iOS 17.0, *)
    func asyncRemoveBackground() async -> UIImage? {
        
        guard let image = inputImage else {
            print("Failed to load input image")
            return nil
        }
        
        let backgorundRemover = BackgroundRemover.shared
        do {
            let processedImage = try backgorundRemover.process(image: image)
            return processedImage
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
