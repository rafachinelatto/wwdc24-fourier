//
//  CameraView.swift
//
//
//  Created by Rafael Antonio Chinelatto on 01/02/24.
//

import SwiftUI

struct CameraView: View {
    
    @StateObject private var model = CameraViewModel()
    
    var body: some View {
        ZStack {
            FrameView(image: model.frame)
                .ignoresSafeArea(edges: .all)
            
            VStack {

                if model.isTaken {
                    
                    HStack {
                        
                        Spacer()
                        
                        Button(action: {}, label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .foregroundStyle(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        })
                        .padding(.trailing, 10)
                    }
                }
                
                Spacer()
                
                HStack {
                    if model.isTaken {
                        
                        Button(action: {} , label: {
                            Text("Use image")
                                .foregroundStyle(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        })
                        .padding(.leading)
                        
                        Spacer()
                    }
                    else {
                        Button {
                            model.isTaken.toggle()
                        } label: {
                            ZStack {
                                
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 75)
                            }
                        }
                    }
                    
                }
            }
            
            CameraErrorView(error: model.error)
        }
    }
}

#Preview {
    CameraView()
}
