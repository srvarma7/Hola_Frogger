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
import AwesomeSpotlightView


class IdentifyViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AwesomeSpotlightViewDelegate {

    // UI outlets.
    @IBOutlet weak var messageLabel: UILabel!
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
    var spotlight: [SpotLightEntity] = []
    var spotlightView = AwesomeSpotlightView()


    let activityView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initailizing and setting properties to capture the frames from camera
        captureSession.sessionPreset = .photo
        
        /// Setting the device to use Normal lens
        ///guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        // Setting the device to use Telephoto lens
        guard let captureDevice = AVCaptureDevice.default(.builtInTelephotoCamera, for: .video, position: .back) else { return }
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
        
        // Showing activity indicator to show the process.
        activityView.style = .large
        activityView.color = UIColor(red: 197/255, green: 26/255, blue: 74/255, alpha: 1)
        activityView.center = circleView.center
        self.view.addSubview(activityView)
        
        // Displaying the Camera feed.
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        checkForSpotLight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Checking if the application is running on simulator or physical device.
        if self.isSimulator {
            // If the application is running on a Simulator, this erroe message is show.
            self.messageLabel.center = self.view.center
            self.messageLabel.text = "Looks like you on an Simulator.....\nTo experience this feature, please open this on a device with camera!"
            self.bgImage.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
            self.bgImage.layer.cornerRadius = (self.bgImage.frame.size.width)/10
        } else {
            // If the application is running on a physical device, it starts identification.
            UIView.animate(withDuration: 2, delay: 0, animations: {
                self.bgImage.layer.cornerRadius = (self.bgImage.frame.size.width)/10
                self.bgImage.clipsToBounds = true
                self.circleView.transform = self.circleView.transform.rotated(by: CGFloat.pi)
                self.circleView.transform = self.circleView.transform.rotated(by: CGFloat.pi)
                self.circleView.layer.cornerRadius = self.circleView.frame.size.width/2
                self.activityView.startAnimating()
                self.captureSession.startRunning()
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // When the view controller is closed or dismissed, the identification process is stopped to stop the battery consumption.
        captureSession.stopRunning()
    }
    
    // Check if the application is opening for the first time
    func checkForSpotLight() {
        if spotlight.isEmpty {
            CoreDataHandler.addSpotLight()
            spotlight = CoreDataHandler.fetchSpotLight()
        }
        if !(spotlight.first!.identity) {
            startSpotLightTour()
        }
    }
    
    
    // If the application is opened for the first time, provide tutorial to the user using spot light.
    func startSpotLightTour() {
        let spotlightMain = AwesomeSpotlight(withRect: CGRect(x: 10, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\nOur classification feature can recognise 18 types of frog from Victoria using our own ML model", isAllowPassTouchesThroughSpotlight: false)
        let spotlight1 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 41, y: 154, width: 330, height: 330), shape: .circle, text: "Point the camera to a frog in the view here and watch the magic below", isAllowPassTouchesThroughSpotlight: false)
        // Spotlight for Frog's Common Name
        let spotlight2 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 33, y: 630, width: 350, height: 150), shape: .roundRectangle, text: "\n\n\nIdentified frogs results with their prediction are shown here", isAllowPassTouchesThroughSpotlight: false)
        // Load spotlights
        let spotlightView = AwesomeSpotlightView(frame: view.frame, spotlight: [spotlightMain, spotlight1, spotlight2])
        spotlightView.cutoutRadius = 8
        spotlightView.delegate = self
        view.addSubview(spotlightView)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            spotlightView.spotlightMaskColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
            spotlightView.enableArrowDown = true
            spotlightView.start()
        }
        //CoreDataHandler.updateSpotLight(attribute: "identity", boolean: true)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        // Sleeps for sometime to change the capture speed.
        usleep(1000000)
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        // Setting the machine learning model to get predictions.
        guard let model = try? VNCoreMLModel(for: FrogImageClassification_Refined().model) else { return }
        // Creating a request to get predictions
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            // Setting the values to the text labels if we get the results.
            if results.count > 3 {
                let firstOb = results[0]
                let secOb = results[1]
                let thirdOb = results[2]
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.textlabel.text = firstOb.identifier
                    if !(firstOb.identifier == "Point the camera to a Forg") {
                        self.activityView.stopAnimating()
                        self.name1Lbl.text = firstOb.identifier
                        self.percentage1Lbl.text = "\(Int(firstOb.confidence * 100))%"
                        self.name2Lbl.text = secOb.identifier
                        self.percentage2Lbl.text = "\(Int(secOb.confidence * 100))%"
                        self.name3Lbl.text = thirdOb.identifier
                        self.percentage3Lbl.text = "\(Int(thirdOb.confidence * 100))%"
                    } else {
                        self.activityView.startAnimating()
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

// Method to identify the device type
/// Author "mbelsky"
/// Reference link - https://stackoverflow.com/questions/24869481/how-to-detect-if-app-is-being-built-for-device-or-simulator-in-swift
extension IdentifyViewController {
    var isSimulator: Bool {
        #if arch(i386) || arch(x86_64)
            return true
        #else
            return false
        #endif
    }
}
