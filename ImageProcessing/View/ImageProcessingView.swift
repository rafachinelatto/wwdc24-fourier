//
//  File.swift
//
//
//  Created by Rafael Antonio Chinelatto on 25/01/24.
//

import Foundation
import SwiftUI

struct ImageLiftingView: View {
    
    @ObservedObject var viewModel = ImageLifitingViewModel()
    @ObservedObject var contourViewModel = ContourDetectorViewModel()
    
    let image = UIImage(resource: .test)
    @State var inputImage: UIImage?
    
    var body: some View {
        
        if !contourViewModel.contours.isEmpty {
            
            ContoursView(contours: contourViewModel.contours)
            
        } else {
            
            VStack {
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                
                
                if let outputImage = viewModel.outputImage {
                    Image(uiImage: outputImage)
                        .resizable()
                        .scaledToFit()
                        .onAppear {
                            self.inputImage = outputImage
                        }
                }
                
                
                if let inputImage = inputImage {
                    Button("Get contours") {
                        Task {
                            contourViewModel.inputImage = inputImage
                            contourViewModel.updateContours()
                        }
                    }
                    
                } else {
                    Button("Remove background") {
                        Task {
                            viewModel.inputImage = image
                            viewModel.removeBackground()
                        }
                    }
                }
            }
        }
    }
}
