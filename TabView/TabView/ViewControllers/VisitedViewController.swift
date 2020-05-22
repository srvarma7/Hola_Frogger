//
//  VisitedViewController.swift
//  TabView
//
//  Created by Varma on 16/05/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import MapKit
import AudioToolbox
import AVFoundation
import Lottie
import AwesomeSpotlightView


class VisitedViewController: UIViewController, CLLocationManagerDelegate, AwesomeSpotlightViewDelegate {

    var receivedFrog: FrogEntity?
    //var unsightedFrog: UnSightedFrogEntity?

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cNameLabel: UILabel!
    @IBOutlet weak var sNameLabel: UILabel!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var locationMgr: CLLocationManager = CLLocationManager()
    let regionRadius: Double = 20000
    var annotaion = FrogAnnotation(title: "", subtitle: "", latitude: 0, longitude: 0)
    var spotlightView = AwesomeSpotlightView()
    var spotlight: [SpotLightEntity] = []
    
    var audioPlayer = AVAudioPlayer()
    
    let closeButton = UIButton()
    var animationView = AnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        SetupLocation()
        play(sound: "frog")
        // Do any additional setup after loading the view.
        //AudioServicesPlaySystemSound(1519) // Actuate "Peek" feedback (weak boom)
        //AudioServicesPlaySystemSound(1520) // Actuate "Pop" feedback (strong boom)
        AudioServicesPlaySystemSound(3000) // Actuate "Nope" feedback (series of three weak booms)
        //play(sound: test)
        checkForSpotLight()
    }
    
    func changeSegment() {
        segmentControl.selectedSegmentIndex = -1
        if receivedFrog!.isVisited {
            sleep(2)
            segmentControl.selectedSegmentIndex = 1
            animationView.removeFromSuperview()
            play(sound: "confetti")
            segmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            lottieAnimation(AnimationName: "confetti1", top: 150, sides: 30, size: 800)
        }
    }
    
    func play(sound: String) {
        let sound = URL(fileURLWithPath: Bundle.main.path(forResource: sound, ofType: "mp3")!)
        do {
             audioPlayer = try AVAudioPlayer(contentsOf: sound)
             audioPlayer.play()
        } catch {  }
    }
    
    func lottieAnimation(AnimationName: String, top: CGFloat, sides: CGFloat, size: CGFloat) {
        animationView = AnimationView(name: AnimationName)
        animationView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundColor = UIColor(white: 0, alpha: 0)
        view.addSubview(animationView)
        animationView.loopMode = .playOnce
        animationView.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.animationView.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.animationView.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupCloseButton()
        UIView.animate(withDuration: 0.5, delay: 1, animations: {
            self.changeSegment()
            self.closeButton.transform = CGAffineTransform(translationX: 0, y: -145)
        })
        setLabels()
    }
    
    func SetupLocation() {
        // To get user location and its accuracy.
        locationMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationMgr.distanceFilter = 10
        locationMgr.delegate = self
        locationMgr.requestAlwaysAuthorization()
        mapView.showsUserLocation = true
        mapView.tintColor = #colorLiteral(red: 0.7719962001, green: 0.1048256829, blue: 0.2892795205, alpha: 1)
        foucsOnUserLoc()
        if !(receivedFrog == nil) {
            annotaion = FrogAnnotation(title: receivedFrog!.cname!, subtitle: receivedFrog!.sname!, latitude: receivedFrog!.latitude, longitude: receivedFrog!.longitude)
            self.mapView.addAnnotation(self.annotaion)
        }
    }
    
    func foucsOnUserLoc() {
        guard let coordinate = locationMgr.location?.coordinate else {return}
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func setLabels() {
        cNameLabel.text = receivedFrog?.cname
        sNameLabel.text = receivedFrog?.sname
        greetingLabel.text = "Hurrah!!! \n You have entered the \(cNameLabel.text!) habitat!!! \n Now, Lets try to sight the Frog"
        imageView.image = UIImage(named: (receivedFrog?.sname)!)
        imageView.backgroundColor = UIColor(white: 0, alpha: 0)
    }

    @IBAction func foucsOnUserLocBtm(_ sender: Any) {
        foucsOnUserLoc()
    }
    
    func setupCloseButton() {
        closeButton.frame = CGRect(x: view.center.x, y: view.frame.maxY + 30, width: 50, height: 50)
        closeButton.center.x = view.center.x
        closeButton.setBackgroundImage(UIImage(systemName: "xmark.circle.fill"), for: UIControl.State.normal)
        closeButton.tintColor = UIColor.red
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        self.view.addSubview(closeButton)
    }
    
    @objc func closeButtonAction(sender: UIButton!) {
        // Sends a notification to the Frog list controller to reload the tableview controller.
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        // Dismisses the current controller.
        dismiss(animated: true)
    }
    
    func updateSightedStatus(receivedFrog: FrogEntity, isVisited: Bool) {
        CoreDataHandler.updateFrog(frog: receivedFrog, isVisited: isVisited, isFavourite: receivedFrog.isFavourite)
        CoreDataHandler.updateUnSightedFrog(unsightedFrog: receivedFrog.cname!, isVisited: receivedFrog.isVisited, isFavourite: receivedFrog.isFavourite)
    }

    @IBAction func segmentedCtrlDidSelect(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            animationView.removeFromSuperview()
            segmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            play(sound: "sad")
            lottieAnimation(AnimationName: "sad2", top: 150, sides: 30, size: 250)
            updateSightedStatus(receivedFrog: receivedFrog!, isVisited: false)
        } else if segmentControl.selectedSegmentIndex == 1 {
            animationView.removeFromSuperview()
            play(sound: "confetti")
            segmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            lottieAnimation(AnimationName: "confetti1", top: 150, sides: 30, size: 800)
            updateSightedStatus(receivedFrog: receivedFrog!, isVisited: true)
        }
    }
    
    // Check if the application is opening for the first time to load spotlight
    func checkForSpotLight() {
        if spotlight.isEmpty {
            CoreDataHandler.addSpotLight()
            spotlight = CoreDataHandler.fetchSpotLight()
        }
        if !(spotlight.first!.visited) {
            startSpotLightTour()
        }
    }
    
    func startSpotLightTour() {
        let spotlightMain = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\nCongratulations on visiting frog's habitat", isAllowPassTouchesThroughSpotlight: false)
        let spotlightMain1 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\nNow to try to sight the frog", isAllowPassTouchesThroughSpotlight: false)
        let spotlight = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 85, y: 620, width: 250, height: 80), shape: .roundRectangle, text: "\nWhen you sight the frog, tap on Yes to record the status and complete the challenge", isAllowPassTouchesThroughSpotlight: false)
        let spotlightMain3 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 200, y: 77, width: 0, height: 0), shape: .circle, text: "\n\n\n\n\n\n\n\n\n\n\nGood luck frogger for sighting the frog", isAllowPassTouchesThroughSpotlight: false)
        
        let spotlightView = AwesomeSpotlightView(frame: view.frame, spotlight: [spotlightMain, spotlightMain1, spotlight, spotlightMain3])
        
        spotlightView.cutoutRadius = 8
        spotlightView.delegate = self
        view.addSubview(spotlightView)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            spotlightView.spotlightMaskColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
            spotlightView.enableArrowDown = true
            spotlightView.start()        }
        CoreDataHandler.updateSpotLight(attribute: "visited", boolean: true)
    }
}
