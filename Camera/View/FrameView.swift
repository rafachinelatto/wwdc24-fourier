//
//  FrameView.swift
//
//
//  Created by Rafael Antonio Chinelatto on 01/02/24.
//

import SwiftUI

struct FrameView: View {
    
    var image: CGImage?
    private let label = Text("Camera feed")
    
    var body: some View {
        if let image = image {
            GeometryReader { geometry in
                
                Image(image, scale: 1.0, orientation: .upMirrored, label: label)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height,
                        alignment: .center)
                    .clipped()
            }
        } else {
            Color.black
        }
    }
}
