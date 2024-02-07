//
//  CameraView.swift
//
//
//  Created by Rafael Antonio Chinelatto on 05/02/24.
//

import SwiftUI
import PhotosUI


struct CameraView: View {
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State var image: UIImage?
    @State var goToImageProcessingView: Bool = false
    
    var body: some View {
        VStack {
            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                
                HStack {
                    Button("Retake") {
                        self.showCamera.toggle()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Use this Image") {
                        goToImageProcessingView = true
                    }
                    .buttonStyle(.borderedProminent)
                    .navigationDestination(isPresented: $goToImageProcessingView) {
                        ImageProcessingView(image: selectedImage)
                    }
                }
            }
            else {
                
                Button("Take a picture") {
                    self.showCamera.toggle()
                }
            }
        }
        .fullScreenCover(isPresented: self.$showCamera) {
            AccessCameraView(selectedImage: self.$selectedImage)
        }
    }
}

