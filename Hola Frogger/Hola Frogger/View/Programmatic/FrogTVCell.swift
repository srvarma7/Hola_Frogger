//
//  FrogTVCell.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 12/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit

class FrogTVCell: UITableViewCell {
    
    // Labels and Images views
    private let frogImageView           = UIImageView()
    private let commonName              = UILabel()
    private let scientificName          = UILabel()
    private let frogThreatenedImageView = UIImageView()
    
    private let frogImageWidthHeight: CGFloat = 80
    private let frogThreatenedImageWidthHeight: CGFloat = 20

    
    var frog: FrogEntity? {
        didSet {
            guard let frogItem = frog else {return}
            if let sciName = frogItem.sname {
                scientificName.text = sciName
                frogImageView.image = UIImage(named: sciName)
                frogImageView.backgroundColor = .clear
            }
            if let commName = frogItem.cname {
                commonName.text = commName
                commonName.font = .boldSystemFont(ofSize: 20)
            }
            if let status = frogItem.threatnedStatus {
                if status == "Not endangered" {
                    frogThreatenedImageView.image = UIImage(systemName: "n.square")
                    frogThreatenedImageView.tintColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
                } else if status == "Vulnerable" {
                    frogThreatenedImageView.image = UIImage(systemName: "v.square.fill")
                    frogThreatenedImageView.tintColor = UIColor(red: 0.3, green: 0, blue: 0.7, alpha: 1)
                } else if status ==  "Endangered" {
                    frogThreatenedImageView.image = UIImage(systemName: "e.square.fill")
                    frogThreatenedImageView.tintColor = UIColor(red: 0.8, green: 0, blue: 0, alpha: 0.8)
                }
                frogThreatenedImageView.backgroundColor = .clear
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
        
        addUIConstriants()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addViews() {
        configureFrogImageView()
        configureCommonNameLabel()
        configureScientificNameLabel()
        configureThreatenedImageView()
    }

    fileprivate func configureFrogImageView() {
        frogImageView.heightAnchor.constraint(equalToConstant: frogImageWidthHeight).isActive  = true
        frogImageView.widthAnchor.constraint(equalToConstant: frogImageWidthHeight).isActive   = true
        frogImageView.image = UIImage(named: "buttonFollowCheckGreen")
        
        contentView.addSubview(frogImageView)
    }
    
    fileprivate func configureCommonNameLabel() {
        commonName.text             = "Common name"
        commonName.textAlignment    = .natural
        commonName.font = UIFont.boldSystemFont(ofSize: 18)
        
        contentView.addSubview(commonName)
    }
    
    fileprivate func configureScientificNameLabel() {
        scientificName.text             = "Scientific name"
        scientificName.textAlignment    = .natural
        scientificName.font = scientificName.font.withSize(17)
        
        contentView.addSubview(scientificName)
    }
    
    fileprivate func configureThreatenedImageView() {
        frogThreatenedImageView.heightAnchor.constraint(equalToConstant: frogThreatenedImageWidthHeight).isActive    = true
        frogThreatenedImageView.widthAnchor.constraint(equalToConstant: frogThreatenedImageWidthHeight).isActive    = true
        frogThreatenedImageView.image = UIImage(named: "buttonFollowCheckGreen")
        
        contentView.addSubview(frogThreatenedImageView)
    }
    
    fileprivate func addUIConstriants() {
        
        frogImageView.addAnchor(top: contentView.topAnchor, paddingTop: 10,
                                left: contentView.leftAnchor, paddingLeft: 10,
                                bottom: nil, paddingBottom: 0,
                                right: nil, paddingRight: 0,
                                width: frogImageWidthHeight, height: frogImageWidthHeight, enableInsets: true)
        
        commonName.addAnchor(top: frogImageView.topAnchor, paddingTop: 10,
                             left: frogImageView.rightAnchor, paddingLeft: 10,
                             bottom: nil, paddingBottom: 0,
                             right: nil, paddingRight: 0,
                             width: 275, height: 30, enableInsets: true)
        
        scientificName.addAnchor(top: nil, paddingTop: 0,
                                 left: frogImageView.rightAnchor, paddingLeft: 10,
                                 bottom: frogImageView.bottomAnchor, paddingBottom: 10,
                                 right: nil, paddingRight: 40,
                                 width: 260, height: 30, enableInsets: true)
        
        frogThreatenedImageView.addAnchor(top: contentView.topAnchor, paddingTop: 40,
                                          left: nil, paddingLeft: 0,
                                          bottom: contentView.bottomAnchor, paddingBottom: 40,
                                          right: contentView.rightAnchor, paddingRight: 15,
                                          width: frogThreatenedImageWidthHeight, height: frogThreatenedImageWidthHeight, enableInsets: true)
    }
    
}
