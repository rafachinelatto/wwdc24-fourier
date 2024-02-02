//
//  CameraViewModel.swift
//
//
//  Created by Rafael Antonio Chinelatto on 02/02/24.
//

import CoreImage

class CameraViewModel: ObservableObject {
    
    @Published var frame: CGImage?
    @Published var error: Error?
    @Published var isTaken: Bool = false
    
    private let frameManager = FrameManager.shared
    private let cameraManager = CameraManager.shared
    
    init() {
        setupSubscriptions()
    }
    
    func setupSubscriptions() {
        frameManager.$current
            .receive(on: RunLoop.main)
            .compactMap { buffer in
                return CGImage.create(from: buffer)
            }
            .assign(to: &$frame)
        
        cameraManager.$error
            .receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: &$error)
    }
}
