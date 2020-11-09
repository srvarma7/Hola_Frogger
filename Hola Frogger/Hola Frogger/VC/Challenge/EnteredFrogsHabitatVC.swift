//
//  EnteredFrogsHabitatVC.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 28/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import MapKit
import AudioToolbox
import AVFoundation
import Lottie

class EnteredFrogsHabitatVC: UIViewController {
    
    var unsightedFrogItem: UnSightedFrogEntity?
    let animationView = AnimationView(name: "confetti1")
    
    var challengeDelegate: ChallengeProtocol?
    
    private var mapView = MKMapView()
    private var frogImageView           = UIImageView()
    
    private var frogCommonNameLabel = UILabel()
    private var frogScientificNameLabel = UILabel()
    private var sightedSegmentedControl = UISegmentedControl()
    
    private var greetingsLabel  = UILabel()
    private var questionLabel = UILabel()
    
    private var closeButton = UIButton()
    
    var audioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        addViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        AudioService().play(sound: SoundType.frog)

        setFrogAnnotationOnMap()
        setFrogDetails()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.animationView.removeFromSuperview()
    }
    
    private func setFrogDetails() {
        guard let frog = unsightedFrogItem else { return }
        frogCommonNameLabel.text = frog.cname
        frogScientificNameLabel.text = frog.sname
        frogImageView.image = UIImage(named: frog.sname!)
        frogImageView.backgroundColor = .clear
    }
}

// MARK:- Add views and constriants
extension EnteredFrogsHabitatVC: MKMapViewDelegate {
    private func setFrogAnnotationOnMap() {
        mapView.delegate = self
        let focusLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.unsightedFrogItem!.latitude,
                                                                              longitude: self.unsightedFrogItem!.longitude),
                                               latitudinalMeters: 1000,
                                               longitudinalMeters: 1000)
        
        
        
        mapView.setRegion(focusLocation, animated: true)
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        let annotation = FrogAnnotation(title: unsightedFrogItem!.cname!,
                                       subtitle: unsightedFrogItem!.sname!,
                                       latitude: unsightedFrogItem!.latitude,
                                       longitude: unsightedFrogItem!.longitude)
        mapView.addAnnotation(annotation)
//        showCircle(coordinate: annotation.coordinate, radius: 10, mapView: mapView)

    }
    
}

extension EnteredFrogsHabitatVC {
    
    @objc private func segmentedControlDidTapped() {
        let selectedIndexTitle = sightedSegmentedControl.titleForSegment(at: sightedSegmentedControl.selectedSegmentIndex)
        if selectedIndexTitle == "Yes" {
            sightedSegmentedControl.selectedSegmentTintColor = .systemGreen
            challengeDelegate?.didUpdateSightedStatus(unsightedFrogEntity: unsightedFrogItem!, status: true)
//            AudioService().play(sound: SoundType.confetti)
            view.addSubview(animationView)
            animationView.pin(to: view)
            animationView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            animationView.play(completion: { _ in
                debugPrint("Finished confetti animation, removing from superview")
                self.animationView.removeFromSuperview()
            })
        } else {
            sightedSegmentedControl.selectedSegmentTintColor = .systemRed
            challengeDelegate?.didUpdateSightedStatus(unsightedFrogEntity: unsightedFrogItem!, status: false)
        }
    }
}

extension EnteredFrogsHabitatVC {
    
    private func addViews() {
        let safeArea = view.safeAreaLayoutGuide
        
        // MARK:- Map
        view.addSubview(mapView)
        mapView.addAnchor(top: safeArea.topAnchor, paddingTop: 0,
                          left: safeArea.leftAnchor, paddingLeft: 0,
                          bottom: nil, paddingBottom: 0,
                          right: safeArea.rightAnchor, paddingRight: 0,
                          width: 0, height: UIScreen.main.bounds.height/3, enableInsets: true)
        
        view.addSubview(frogImageView)
        frogImageView.addAnchor(top: mapView.bottomAnchor, paddingTop: -50,
                                left: nil, paddingLeft: 0,
                                bottom: nil, paddingBottom: 0,
                                right: nil, paddingRight: 0,
                                width: 100, height: 100, enableInsets: true)
        
        frogImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(frogCommonNameLabel)
        frogCommonNameLabel.addAnchor(top: mapView.bottomAnchor, paddingTop: 60,
                                      left: nil, paddingLeft: 0,
                                      bottom: nil, paddingBottom: 0,
                                      right: nil, paddingRight: 0,
                                      width: 0, height: 0, enableInsets: true)
        frogCommonNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        frogCommonNameLabel.text = "Common Name Label"
        frogCommonNameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        view.addSubview(frogScientificNameLabel)
        frogScientificNameLabel.addAnchor(top: frogCommonNameLabel.bottomAnchor, paddingTop: 5,
                                          left: nil, paddingLeft: 0,
                                          bottom: nil, paddingBottom: 0,
                                          right: nil, paddingRight: 0,
                                          width: 0, height: 0, enableInsets: true)
        frogScientificNameLabel.text = "Scientific Name Label"
        frogScientificNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        frogScientificNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        frogScientificNameLabel.textColor = .secondaryLabel
        
        view.addSubview(greetingsLabel)
        greetingsLabel.textAlignment = .center
        greetingsLabel.text = "Hurrah!!!\nYou have entered the frog's habitat!!\nNow, Let's try to sight the Frog.\n\n"
        greetingsLabel.numberOfLines = 0
        greetingsLabel.addAnchor(top: frogScientificNameLabel.bottomAnchor, paddingTop: 20,
                                 left: safeArea.leftAnchor, paddingLeft: 20,
                                 bottom: nil, paddingBottom: 0,
                                 right: safeArea.rightAnchor, paddingRight: 20,
                                 width: 0, height: 0, enableInsets: true)
        
        view.addSubview(questionLabel)
        questionLabel.textAlignment = .center
        questionLabel.text = "Did you sight the frog???"
        questionLabel.addAnchor(top: greetingsLabel.bottomAnchor, paddingTop: 10,
                                left: safeArea.leftAnchor, paddingLeft: 20,
                                bottom: nil, paddingBottom: 0,
                                right: safeArea.rightAnchor, paddingRight: 20,
                                width: 0, height: 0, enableInsets: true)
        
        view.addSubview(sightedSegmentedControl)
        sightedSegmentedControl.addAnchor(top: questionLabel.bottomAnchor, paddingTop: 10,
                                          left: safeArea.leftAnchor, paddingLeft: 50,
                                          bottom: nil, paddingBottom: 0,
                                          right: safeArea.rightAnchor, paddingRight: 50,
                                          width: 0, height: 0, enableInsets: true)
        configureSegmentedControl()
        
        view.addSubview(closeButton)
        closeButton.addAnchor(top: nil, paddingTop: 0,
                              left: nil, paddingLeft: 0,
                              bottom: safeArea.bottomAnchor, paddingBottom: 30,
                              right: nil, paddingRight: 0,
                              width: 50, height: 50,
                              enableInsets: true)
        closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        closeButton.setBackgroundImage(UIImage(systemName: "xmark.circle.fill"), for: UIControl.State.normal)
        closeButton.tintColor = UIColor.red
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
    }
    
    private func configureSegmentedControl() {
        sightedSegmentedControl.insertSegment(withTitle: "Yes", at: 0, animated: true)
        sightedSegmentedControl.insertSegment(withTitle: "No", at: 1, animated: true)
        
        // Tap action
        sightedSegmentedControl.addTarget(self, action: #selector(segmentedControlDidTapped), for: .valueChanged)
        
    }
    
    @objc func closeButtonAction(sender: UIButton!) {
        // Dismisses the current controller.
        dismiss(animated: true)
    }
    
}
