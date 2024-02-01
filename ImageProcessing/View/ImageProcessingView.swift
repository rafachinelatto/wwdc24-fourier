//
//  ImageProcessingView.swift
//
//
//  Created by Rafael Antonio Chinelatto on 30/01/24.
//

import SwiftUI

struct ImageProcessingView: View {
    
    @ObservedObject var model = ImageProcessingViewModel()
    
    let image = UIImage(resource: .eu4)
    
    var body: some View {
        
        if !model.contours.isEmpty {
            ContoursView(contours: model.contours)
        }
        
        else {
            
            VStack {
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
