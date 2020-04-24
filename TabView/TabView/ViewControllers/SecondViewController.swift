//
//  SecondViewController.swift
//  TabView
//
//  Created by Varma on 12/04/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import AVKit
import Vision

class SecondViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var textlabel: UILabel!
    
    @IBOutlet weak var name1Lbl: UILabel!
    @IBOutlet weak var name2Lbl: UILabel!
    @IBOutlet weak var name3Lbl: UILabel!
    
    
    @IBOutlet weak var percentage1Lbl: UILabel!
    @IBOutlet weak var percentage2Lbl: UILabel!
    @IBOutlet weak var percentage3Lbl: UILabel!
    
    
    
    var circleView: UIView!
    let captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Initailizing and setting properties to capture the frames from camera
        captureSession.sessionPreset = .photo
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        // Adding a new View on top and making changing the shape to circle.
        circleView = UIView(frame: CGRect(x: 0, y: 170, width: 300, height: 300))
        circleView.center.x = view.center.x
        circleView.clipsToBounds = true
        view.addSubview(circleView)
        
        // Layer to show the Output.
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        circleView.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = CGRect(x: -50, y: 0, width: 400, height: 400)
        
        // Displaying the Camera feed.
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIView.animate(withDuration: 2, animations: {
            //self.bgImage.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            self.bgImage.layer.cornerRadius = (self.bgImage.frame.size.width)/10
            self.bgImage.clipsToBounds = true
            UIView.animate(withDuration: 2, animations: {
                if !self.isSimulator {
                    self.circleView.transform = self.circleView.transform.rotated(by: CGFloat.pi)
                    self.circleView.transform = self.circleView.transform.rotated(by: CGFloat.pi)
                    self.circleView.layer.cornerRadius = self.circleView.frame.size.width/2
                }
            })
        })
        self.captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        captureSession.stopRunning()
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        sleep(1)
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: FrogImageClassification_Refined().model) else { return }
        
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            
            if results.count > 3 {
                let firstOb = results[0]
                let secOb = results[1]
                let thirdOb = results[2]
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.textlabel.text = firstOb.identifier
                    if !(firstOb.identifier == "Point the camera to a Forg") {
                        self.name1Lbl.text = firstOb.identifier
                        self.percentage1Lbl.text = "\(Int(firstOb.confidence * 100))%"
                        self.name2Lbl.text = secOb.identifier
                        self.percentage2Lbl.text = "\(Int(secOb.confidence * 100))%"
                        self.name3Lbl.text = thirdOb.identifier
                        self.percentage3Lbl.text = "\(Int(thirdOb.confidence * 100))%"
                    } else {
                        self.name1Lbl.text = ""
                        self.percentage1Lbl.text = ""
                        self.name2Lbl.text = ""
                        self.percentage2Lbl.text = ""
                        self.name3Lbl.text = ""
                        self.percentage3Lbl.text = ""
                    }
                }
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}

extension SecondViewController {
    var isSimulator: Bool {
        #if arch(i386) || arch(x86_64)
            return true
        #else
            return false
        #endif
    }
}
