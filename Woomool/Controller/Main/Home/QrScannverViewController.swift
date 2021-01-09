//
//  QrScannverViewController.swift
//  Woomool
//
//  Created by Dustin on 2020/08/27.
//  Copyright © 2020 Woomool. All rights reserved.
//

import UIKit
import AVFoundation

class QrScannverViewController: UIViewController {
    
    
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    lazy var notiView : UIView = QrViewModel().NotiView(label:mainLabel)
    
    let storeLookUpModel = StoreLookUpModel()
    
    private let mainLabel : UILabel = {
        let lb = UILabel()
        lb.text = "QR코드를 스캔해주세요."
        lb.textColor = .blue500
        lb.font = UIFont.systemFont(ofSize: 18)
        return lb
    }()
    
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "QR코드 스캔"
        
        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        view.addSubview(notiView)

        notiView.anchor(top:view.safeAreaLayoutGuide.topAnchor,left:view.leftAnchor,right: view.rightAnchor,paddingTop: 12,paddingLeft: 11,paddingRight: 9)
        notiView.bringSubviewToFront(notiView)
        
        
//        view.addSubview(qrcodePreView)
//        qrcodePreView.center(inView: view)
//        qrcodePreView.bringSubviewToFront(qrcodePreView)
        
        // Start video capture.
        captureSession.startRunning()
        
        // Move the message label and top bar to the front
        
        // Initialize QR Code Frame to highlight the QR code
//        qrCodeFrameView = UIView()
//
//        if let qrCodeFrameView = qrCodeFrameView {
//            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
//            qrCodeFrameView.layer.borderWidth = 2
//            view.addSubview(qrCodeFrameView)
//            view.bringSubviewToFront(qrCodeFrameView)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tabBarController?.tabBar.isHidden = true
                NotificationCenter.default.addObserver(self, selector: #selector(popToView(noti:)), name: NSNotification.Name("pop"), object: nil)

  self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "left_arrow"), style: .plain, target: self, action: #selector(handledismiss))
        
        navigationItem.leftBarButtonItem?.tintColor = .black900
        
    }
    
    @objc func handledismiss() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func popToView(noti : NSNotification) {
         //내가 전송해했던 키네임 불러오기 , 타입 불러오기
        self.navigationController?.popViewController(animated: true)
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper methods
    
    func launchApp(storeId: String) {
        
        if presentedViewController != nil {
            return
        }
        
        APIRequest.shared.getStoreLookUp(storeId: storeId) { json in
            self.storeLookUpModel.name = json["name"].stringValue
            self.storeLookUpModel.storeId = json["storeId"].stringValue
            let controller = QrAuthViewController()
            controller.modalPresentationStyle = .overCurrentContext
            controller.storeLookUpModel = self.storeLookUpModel
            self.present(controller, animated: true, completion: nil)
            
        } fail: { error in
            self.showOkAlert(title:  "[\(error.status)] \(error.code)=\(error.message)", message: "") {
                
            }
        }

    }
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        layer.videoOrientation = orientation
        videoPreviewLayer?.frame = self.view.bounds
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let connection =  self.videoPreviewLayer?.connection  {
            let currentDevice: UIDevice = UIDevice.current
            let orientation: UIDeviceOrientation = currentDevice.orientation
            let previewLayerConnection : AVCaptureConnection = connection
            
            if previewLayerConnection.isVideoOrientationSupported {
                switch (orientation) {
                case .portrait:
                    updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                    break
                case .landscapeRight:
                    updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
                    break
                case .landscapeLeft:
                    updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
                    break
                case .portraitUpsideDown:
                    updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
                    break
                default:
                    updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                    break
                }
            }
        }
    }
    
}

extension QrScannverViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
//
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
//            qrCodeFrameView?.frame = barCodeObject!.bounds
//            qrcodePreView.isHidden = true
            
            if metadataObj.stringValue != nil {
                launchApp(storeId: metadataObj.stringValue!)
                

                
            }
        }
    }
    
}


