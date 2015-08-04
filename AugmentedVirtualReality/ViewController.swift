//
//  ViewController.swift
//  AugmentedVirtualReality
//
//  Created by Alex Prevoteau on 8/2/15.
//  Copyright (c) 2015 Alex Prevoteau. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // Set the varible for the Camera View (as "cv")
    let cv = UIView()
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    
    //Prevent the status bar from displaying
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //Request autorotate not to be invoked
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    //Force Landscape Left orientation
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.LandscapeLeft.rawValue
    }
    
    //Setup after loading the attached view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set a CGRect variable to hold the device screen dimensions
        let screenRect = UIScreen.mainScreen().bounds
        
        //Create a Core Animation Replicator Layer and set its position
        let r = CAReplicatorLayer()
        r.bounds = CGRect(x: 0.0, y: 0.0, width: screenRect.width, height: screenRect.height)
        r.position = view.center

        //Add the replicator layer as a subview
        view.layer.addSublayer(r)
        
        //Add the camera view as a subview
        view.addSubview(cv)
        
        //Add the camera view's Core Animation layer as a sublayer to the replicator view's CALayer
        //creating two streaming images with an offset to create a "3D" effect when the phone viewed
        //within a mobile VR enclosure.
        r.addSublayer(cv.layer)
        r.instanceCount = 2
        r.instanceTransform = CATransform3DMakeTranslation(0.0, 353.0, 0.0)
        
        //Position the camera view appropriately
        cv.layer.bounds = CGRect(x: 0.0, y: 0.0, width: screenRect.width, height: screenRect.height * 1.06)
        cv.layer.position = CGPoint(x: 187, y: 335)
        cv.layer.backgroundColor = UIColor.blackColor().CGColor
        
        // Do any additional setup after loading the view, typically from a nib.
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        //Set a varibale to hold all capture found
        let devices = AVCaptureDevice.devices()
        
        //Find the back camera and start streaming video
        for device in devices {
            if (device.hasMediaType(AVMediaTypeVideo)) {
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        println("Capture device found")
                        beginSession()
                        UIApplication.sharedApplication().idleTimerDisabled = true
                    }
                }
            }
        }
    }
    
    //Function to begin camera capture session
    func beginSession() {
        
        var err : NSError? = nil
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cv.layer.addSublayer(previewLayer)
        previewLayer?.frame = cv.layer.frame
        captureSession.startRunning()
    }
    
    
}
