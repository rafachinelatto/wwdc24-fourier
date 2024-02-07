//
//  ImageProcessingView.swift
//
//
//  Created by Rafael Antonio Chinelatto on 30/01/24.
//

import SwiftUI

struct ImageProcessingView: View {
    
    @ObservedObject var model = ImageProcessingViewModel()
    
    let image: UIImage
    
    var body: some View {
        
        if !model.contours.isEmpty {
            VStack {
                
                if let outputImage = model.outputImage {
                    Image(uiImage: outputImage)
                        .resizable()
                        .scaledToFit()
                }
                
                ContoursView(contours: model.contours)
            }
        }
        
        else {
            
            VStack {
                if let outputImage = model.outputImage {
                    Text("Getting contours ...")
                    Image(uiImage: outputImage)
                        .resizable()
                        .scaledToFit()
                    
                } else {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                    
                    Button("Get contours") {
                        Task {
                            model.inputImage = image
                            model.processImage()
                        }
                    }
                }
            }
        }
    }
}
