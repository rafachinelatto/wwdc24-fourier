//
//  CameraManager.swift
//
//
//  Created by Rafael Antonio Chinelatto on 01/02/24.
//

import AVFoundation

class CameraManager: ObservableObject {
    
    enum Status {
        case unconfigured
        case configured
        case unauthotized
        case failed
    }
    
    static let shared = CameraManager()
    
    @Published var error: CameraError?
    
    let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "com.rafachinelatto.SessionQ")
    private let videoOutput = AVCaptureVideoDataOutput()
    private var status = Status.unconfigured
    
    private init() {
        configure()
    }
    
    
    private func configure() {
        checkPermissions()
        sessionQueue.async {
            self.configureCaptureSession()
            self.session.startRunning()
        }
    }
    
    
    private func set(error: CameraError?) {
        DispatchQueue.main.async {
            self.error = error
        }
    }
    
    
    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                if !authorized {
                    self.status = .unauthotized
                    self.set(error: .deniedAuthorization)
                }
                self.sessionQueue.resume()
            }
        case .restricted:
            status = .unauthotized
            set(error: .restrictedAuthorization)
        case .denied:
            status = .unauthotized
            set(error: .deniedAuthorization)
        case .authorized:
            break
        @unknown default:
            status = .unauthotized
            set(error: .unknownAuthorization)
        }
    }
    
    
    private func configureCaptureSession() {
        guard status == .unconfigured else { return }
        
        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }
        
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        guard let camera = device else {
            set(error: .cameraUnavailable)
            status = .failed
            return
        }
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            
            if session.canAddInput(cameraInput) {
                session.addInput(cameraInput)
            } else {
                set(error: .cannotAddInput)
                status = .failed
                return
            }
            
        } catch {
            set(error: .createCaptureInput(error))
            status = .failed
            return
        }
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            
            let videoConnection = videoOutput.connection(with: .video)
            videoConnection?.videoOrientation = .portrait
            
        } else {
            set(error: .cannotAddOutput)
            status = .failed
        }
        status = .configured
    }
    
    func set(_ delegate: AVCaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue) {
        sessionQueue.async {
            self.videoOutput.setSampleBufferDelegate(delegate, queue: queue)
        }
    }
    
    func takePic() {
        sessionQueue.async {
            self.session.stopRunning()
        }
    }
}
