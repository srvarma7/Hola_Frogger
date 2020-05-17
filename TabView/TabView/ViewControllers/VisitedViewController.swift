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

class VisitedViewController: UIViewController, CLLocationManagerDelegate {

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
        //greetingLabel.text = "Hurrah!!! \n You have entered the \(cNameLabel.text) habitat!!! \n Now, Lets try to sight the Frog"
        imageView.image = UIImage(named: "shutter")
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
        let unsightedFrog: UnSightedFrogEntity? = UnSightedFrogEntity()
        unsightedFrog!.cname = receivedFrog.cname
        unsightedFrog!.sname = receivedFrog.sname
        unsightedFrog!.desc = receivedFrog.desc
        unsightedFrog!.frogcount = receivedFrog.frogcount
        unsightedFrog!.isFavourite = receivedFrog.isFavourite
        unsightedFrog!.isVisited = receivedFrog.isVisited
        unsightedFrog!.latitude = receivedFrog.latitude
        unsightedFrog!.longitude = receivedFrog.longitude
        unsightedFrog!.threatnedStatus = receivedFrog.threatnedStatus
        unsightedFrog!.uncertainty = receivedFrog.uncertainty
        CoreDataHandler.updateUnSightedFrog(unsightedFrog: unsightedFrog!, isVisited: isVisited, isFavourite: unsightedFrog!.isFavourite)
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
}
