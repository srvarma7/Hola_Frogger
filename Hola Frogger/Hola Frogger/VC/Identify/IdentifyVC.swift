//
//  IdentifyVC.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 21/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit

import AVKit
import Vision

class IdentifyVC: UIViewController {

    // UI Elements
    private var topView = UIView()
    private var bottomView = UIView()
    
    private var vcHeadingLabel = UILabel()
    
    private var resultsHeadingLabel = UILabel()
    private var resultStatusLabel = UILabel()
    
    private var firstPredictionName = UILabel()
    private var firstPredictionPercentage = UILabel()
    private var secondPredictionName = UILabel()
    private var secondPredictionPercentage = UILabel()
    private var thirdPredictionName = UILabel()
    private var thirdPredictionPercentage = UILabel()
    
    private let captureSession = AVCaptureSession()
    private var circleView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let viewWidth: CGFloat  = 350
        let viewHeight: CGFloat = 350
        let circleViewYPosition: CGFloat = 130
        
        setupCircleViewForCameraPreview(yPosition: circleViewYPosition ,width: viewWidth, height: viewHeight)
        setupPreview(width: viewWidth, height: viewHeight)
        
        
        addBottomView()
        
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateCircle(toCircle: true, rotate: true)
        debugPrint("Starting capture session")
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // When the view controller is closed or dismissed, the identification process is stopped to stop the battery consumption.
        debugPrint("Stopping capture session")
        captureSession.stopRunning()
    }
    
    
}

// MARK: - 
extension IdentifyVC: AVCaptureVideoDataOutputSampleBufferDelegate {
    private func setupPreview(width: CGFloat, height: CGFloat) {
        let scaleSize: CGFloat  = 1.77

        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        circleView.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = CGRect(x: 0, y: -(height/3), width: width, height: height * scaleSize)
        
        // Displaying the Camera feed.
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
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
                self.setPredictionDataToLabels(results: results)
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    private func setPredictionDataToLabels(results: [VNClassificationObservation]) {
        let firstOb = results[0]
        let secOb = results[1]
        let thirdOb = results[2]
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.resultStatusLabel.text = firstOb.identifier
            if !(firstOb.identifier == "Point the camera to a Forg") {
                self.firstPredictionName.text = firstOb.identifier
                self.firstPredictionPercentage.text = "\(Int(firstOb.confidence * 100))%"
                self.secondPredictionName.text = secOb.identifier
                self.secondPredictionPercentage.text = "\(Int(secOb.confidence * 100))%"
                self.thirdPredictionName.text = thirdOb.identifier
                self.thirdPredictionPercentage.text = "\(Int(thirdOb.confidence * 100))%"
            } else {
                self.firstPredictionName.text = ""
                self.firstPredictionPercentage.text = ""
                self.secondPredictionName.text = ""
                self.secondPredictionPercentage.text = ""
                self.thirdPredictionName.text = ""
                self.thirdPredictionPercentage.text = ""
            }
        }
    }
}

// MARK: - Adding views and layout
extension IdentifyVC {
    
    private func setupCircleViewForCameraPreview(yPosition: CGFloat,width: CGFloat, height: CGFloat) {
        circleView = UIView(frame: CGRect(x: 0, y: yPosition, width: width, height: height))
        circleView.center.x = view.center.x
        circleView.clipsToBounds = true
        view.addSubview(circleView)
    }
    
    private func animateCircle(toCircle: Bool, rotate: Bool) {
        UIView.animate(withDuration: 2,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: { [self] in
                        if rotate {
                            circleView.transform = circleView.transform.rotated(by: CGFloat.pi)
                            circleView.transform = circleView.transform.rotated(by: CGFloat.pi)
                        }
                        if toCircle {
                            circleView.layer.cornerRadius = circleView.frame.size.width/2
                        }
                       }, completion: { _ in
                        self.circleView.clipsToBounds = true
                        
                       })
    }
    
    private func addBottomView() {
        view.addSubview(bottomView)
        
        bottomView.layer.cornerRadius   = 20
        bottomView.clipsToBounds        = true
        bottomView.backgroundColor      = .raspberryPieTint()
        bottomView.addAnchor(top: nil, paddingTop: 0,
                             left: view.leftAnchor, paddingLeft: 0,
                             bottom: view.bottomAnchor, paddingBottom: 0,
                             right: view.rightAnchor, paddingRight: 0,
                             width: 0, height: 290,
                             enableInsets: true)
        
        bottomView.addSubview(resultsHeadingLabel)
        resultsHeadingLabel.text = "Results"
        resultsHeadingLabel.font           = UIFont.systemFont(ofSize: 24, weight: .bold)
        resultsHeadingLabel.textColor      = .white
        resultsHeadingLabel.textAlignment  = .center
        resultsHeadingLabel.addAnchor(top: bottomView.topAnchor, paddingTop: 20,
                                      left: bottomView.leftAnchor, paddingLeft: 20,
                                      bottom: nil, paddingBottom: 0,
                                      right: bottomView.rightAnchor, paddingRight: 20,
                                      width: 0, height: 0, enableInsets: false)
        
        bottomView.addSubview(resultStatusLabel)
        resultStatusLabel.text          = "Status"
        resultStatusLabel.font          = UIFont.systemFont(ofSize: 18, weight: .heavy)
        resultStatusLabel.textColor     = .white
        resultStatusLabel.textAlignment = .center
        resultStatusLabel.addAnchor(top: resultsHeadingLabel.bottomAnchor, paddingTop: 5,
                                    left: bottomView.leftAnchor, paddingLeft: 20,
                                    bottom: nil, paddingBottom: 0,
                                    right: bottomView.rightAnchor, paddingRight: 20,
                                    width: 0, height: 0, enableInsets: false)
        
        let fontSize: CGFloat           = 18
        let fontWeight: UIFont.Weight   = .regular
        let leftRightPadding: CGFloat   = 20
        
        bottomView.addSubview(firstPredictionName)
        firstPredictionName.text          = "First name"
        firstPredictionName.font          = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        firstPredictionName.textColor     = .white
        firstPredictionName.textAlignment = .left
        firstPredictionName.addAnchor(top: resultStatusLabel.bottomAnchor, paddingTop: 20,
                                      left: bottomView.leftAnchor, paddingLeft: leftRightPadding,
                                      bottom: nil, paddingBottom: 0,
                                      right: nil, paddingRight: 0,
                                      width: 0, height: 0, enableInsets: false)
        
        bottomView.addSubview(firstPredictionPercentage)
        firstPredictionPercentage.text          = "First percentage"
        firstPredictionPercentage.font          = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        firstPredictionPercentage.textColor     = .white
        firstPredictionPercentage.textAlignment = .right
        firstPredictionPercentage.addAnchor(top: resultStatusLabel.bottomAnchor, paddingTop: 10,
                                      left: nil, paddingLeft: 0,
                                      bottom: nil, paddingBottom: 0,
                                      right: bottomView.rightAnchor, paddingRight: leftRightPadding,
                                      width: 0, height: 0, enableInsets: false)
        
        bottomView.addSubview(secondPredictionName)
        secondPredictionName.text          = "Second name"
        secondPredictionName.font          = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        secondPredictionName.textColor     = .white
        secondPredictionName.textAlignment = .left
        secondPredictionName.addAnchor(top: firstPredictionName.bottomAnchor, paddingTop: 10,
                                      left: bottomView.leftAnchor, paddingLeft: leftRightPadding,
                                      bottom: nil, paddingBottom: 0,
                                      right: nil, paddingRight: 0,
                                      width: 0, height: 0, enableInsets: false)
        
        bottomView.addSubview(secondPredictionPercentage)
        secondPredictionPercentage.text          = "Second percentage"
        secondPredictionPercentage.font          = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        secondPredictionPercentage.textColor     = .white
        secondPredictionPercentage.textAlignment = .right
        secondPredictionPercentage.addAnchor(top: firstPredictionPercentage.bottomAnchor, paddingTop: 10,
                                      left: nil, paddingLeft: 0,
                                      bottom: nil, paddingBottom: 0,
                                      right: bottomView.rightAnchor, paddingRight: leftRightPadding,
                                      width: 0, height: 0, enableInsets: false)
        
        bottomView.addSubview(thirdPredictionName)
        thirdPredictionName.text          = "Third name"
        thirdPredictionName.font          = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        thirdPredictionName.textColor     = .white
        thirdPredictionName.textAlignment = .left
        thirdPredictionName.addAnchor(top: secondPredictionName.bottomAnchor, paddingTop: 10,
                                      left: bottomView.leftAnchor, paddingLeft: leftRightPadding,
                                      bottom: nil, paddingBottom: 0,
                                      right: nil, paddingRight: 0,
                                      width: 0, height: 0, enableInsets: false)
        
        bottomView.addSubview(thirdPredictionPercentage)
        thirdPredictionPercentage.text          = "Third percentage"
        thirdPredictionPercentage.font          = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        thirdPredictionPercentage.textColor     = .white
        thirdPredictionPercentage.textAlignment = .right
        thirdPredictionPercentage.addAnchor(top: secondPredictionPercentage.bottomAnchor, paddingTop: 10,
                                      left: nil, paddingLeft: 0,
                                      bottom: nil, paddingBottom: 0,
                                      right: bottomView.rightAnchor, paddingRight: leftRightPadding,
                                      width: 0, height: 0, enableInsets: false)
        
    }
}
