//
//  ChallengeCVCell.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 27/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import CoreLocation

class ChallengeCVCell: UICollectionViewCell {
    
    var frogItem: UnSightedFrogEntity? {
        didSet {
            guard let frog = frogItem else { return }
            frogImage.image = UIImage(named: frog.sname!)
            commonName.text = frog.cname
            scientificName.text = frog.sname
            visitedStatus.text = frog.isVisited ? "You have sighted" : "Yet to sight"
            contentView.backgroundColor = frog.isVisited ?
                UIColor(red: 0, green: 0.6, blue: 0, alpha: 0.7) :
                UIColor(red: 0.8, green: 0, blue: 0, alpha: 0.7)
            location.text = "Estimated frog count - \(frog.frogcount)"
        }
    }
    
    // UI
    private var frogImage       = UIImageView()
    private var commonName      = UILabel()
    private var scientificName  = UILabel()
    private var location        = UILabel()
    private var visitedStatus   = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .green
        addViews()
        addCorner()
//        addShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChallengeCVCell {
    
    private func addViews() {
        contentView.addSubview(frogImage)
        frogImage.addAnchor(top: contentView.topAnchor, paddingTop: 0,
                            left: nil, paddingLeft: 0,
                            bottom: nil, paddingBottom: 0,
                            right: nil, paddingRight: 0,
                            width: contentView.frame.width/1.5, height: contentView.frame.width/1.5,
                            enableInsets: false)
        frogImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        contentView.addSubview(commonName)
        commonName.text = "Common Name"
        commonName.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        commonName.textColor = .white
        commonName.numberOfLines = 0
        commonName.addAnchor(top: frogImage.bottomAnchor, paddingTop: 0,
                             left: contentView.leftAnchor, paddingLeft: 20,
                             bottom: nil, paddingBottom: 0,
                             right: contentView.rightAnchor, paddingRight: 20,
                             width: 0, height: 0,
                             enableInsets: false)
        
        contentView.addSubview(scientificName)
        scientificName.text = "Scientific name"
        scientificName.font = UIFont.boldSystemFont(ofSize: 18)
        scientificName.textColor = .white
        scientificName.numberOfLines = 0
        scientificName.addAnchor(top: commonName.bottomAnchor, paddingTop: 0,
                                 left: commonName.leftAnchor, paddingLeft: 0,
                                 bottom: nil, paddingBottom: 0,
                                 right: commonName.rightAnchor, paddingRight: 0,
                                 width: 0, height: 0,
                                 enableInsets: false)
        
        contentView.addSubview(location)
        location.text = "Location"
        location.font = UIFont.boldSystemFont(ofSize: 18)
        location.textColor = .white
        location.numberOfLines = 0
        location.addAnchor(top: scientificName.bottomAnchor, paddingTop: 5,
                           left: scientificName.leftAnchor, paddingLeft: 0,
                           bottom: nil, paddingBottom: 0,
                           right: commonName.rightAnchor, paddingRight: 0,
                           width: 0, height: 0,
                           enableInsets: false)
        
        contentView.addSubview(visitedStatus)
        visitedStatus.text = "Visited"
        visitedStatus.font = UIFont.boldSystemFont(ofSize: 18)
        visitedStatus.textColor = .white
        visitedStatus.numberOfLines = 0
        visitedStatus.addAnchor(top: location.bottomAnchor, paddingTop: 5,
                                left: location.leftAnchor, paddingLeft: 0,
                                bottom: nil, paddingBottom: 0,
                                right: commonName.rightAnchor, paddingRight: 0,
                                width: 0, height: 0,
                                enableInsets: false)
    }
    
    private func addCorner() {
        contentView.layer.cornerRadius = 4.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    }
    
    private func addShadow() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = true
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}
