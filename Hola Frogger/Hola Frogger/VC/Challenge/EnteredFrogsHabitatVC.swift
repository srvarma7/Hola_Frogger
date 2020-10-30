//
//  EnteredFrogsHabitatVC.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 28/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import MapKit

class EnteredFrogsHabitatVC: UIViewController {
    
    var unsightedFrogItem: UnSightedFrogEntity? {
        didSet {
            guard let frog = unsightedFrogItem else { return }
            frogCommonNameLabel.text = frog.cname
            frogScientificNameLabel.text = frog.sname
        }
    }
    
    var challengeDelegate: ChallengeProtocol?
        
    private var mapView = MKMapView()

    private var frogImageView           = UIImageView()
    
    private var frogCommonNameLabel = UILabel()
    private var frogScientificNameLabel = UILabel()
    private var sightedSegmentedControl = UISegmentedControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        addViews()
    }

}

extension EnteredFrogsHabitatVC {
    
    @objc private func segmentedControlDidTapped() {
        let selectedIndexTitle = sightedSegmentedControl.titleForSegment(at: sightedSegmentedControl.selectedSegmentIndex)
        if selectedIndexTitle == "Yes" {
            sightedSegmentedControl.selectedSegmentTintColor = .systemGreen
            challengeDelegate?.didUpdateSightedStatus(unsightedFrogEntity: unsightedFrogItem!, status: true)
        } else {
            sightedSegmentedControl.selectedSegmentTintColor = .systemRed
            challengeDelegate?.didUpdateSightedStatus(unsightedFrogEntity: unsightedFrogItem!, status: false)
        }
    }
}

extension EnteredFrogsHabitatVC {
    
    private func addViews() {
        addLabels()
        addSegmentedControl()
        configureSegmentedControl()
    }
    
    private func addLabels() {
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(frogCommonNameLabel)
        frogCommonNameLabel.textAlignment = .center
        frogCommonNameLabel.addAnchor(top: safeArea.topAnchor, paddingTop: 20,
                             left: safeArea.leftAnchor, paddingLeft: 20,
                             bottom: nil, paddingBottom: 0,
                             right: safeArea.rightAnchor, paddingRight: 20,
                             width: 0, height: 0, enableInsets: true)
        
        view.addSubview(frogScientificNameLabel)
        frogScientificNameLabel.textAlignment = .center
        frogScientificNameLabel.addAnchor(top: frogCommonNameLabel.bottomAnchor, paddingTop: 5,
                                 left: frogCommonNameLabel.leftAnchor, paddingLeft: 0,
                                 bottom: nil, paddingBottom: 0,
                                 right: frogCommonNameLabel.rightAnchor, paddingRight: 0,
                                 width: 0, height: 0, enableInsets: true)
        
    }
    
    private func addSegmentedControl() {
        view.addSubview(sightedSegmentedControl)
        sightedSegmentedControl.addAnchor(top: frogScientificNameLabel.bottomAnchor, paddingTop: 50,
                                          left: view.leftAnchor, paddingLeft: 50,
                                          bottom: nil, paddingBottom: 0,
                                          right: view.rightAnchor, paddingRight: 50,
                                          width: 0, height: 0, enableInsets: true)
        
    }
    
    private func configureSegmentedControl() {
        sightedSegmentedControl.insertSegment(withTitle: "Yes", at: 0, animated: true)
        sightedSegmentedControl.insertSegment(withTitle: "No", at: 1, animated: true)
            
        // Tap action
        sightedSegmentedControl.addTarget(self, action: #selector(segmentedControlDidTapped), for: .valueChanged)
        
    }
}
