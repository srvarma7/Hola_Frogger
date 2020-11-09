//
//  NewsTVCell.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 13/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit

class NewsTVCell: UITableViewCell {
    
    private var heading     = UILabel()
    private var subheading  = UILabel()
    private var imgView     = UIImageView()

    var article: Article? {
        didSet {
            guard let articleItem = article else { return }
            heading.text    = articleItem.title
            heading.font    = .boldSystemFont(ofSize: 20)
            heading.numberOfLines = 0
            
            subheading.text = articleItem.description
            subheading.font = .systemFont(ofSize: 17)
            subheading.numberOfLines = 0
            subheading.alpha = 0.7
            
            imgView.image = UIImage(systemName: "square.and.pencil")
            imgView.tintColor = .raspberryPieTint()
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        configureViews()
    }
    
    private func configureViews() {
        
        contentView.addSubview(heading)        
        contentView.addSubview(subheading)
        contentView.addSubview(imgView)
        
        addConstraints()
    }
    
    private func addConstraints() {
        imgView.addAnchor(top: contentView.topAnchor, paddingTop: 15,
                          left: contentView.leftAnchor, paddingLeft: 10,
                          bottom: nil, paddingBottom: 0,
                          right: nil, paddingRight: 0,
                          width: 20, height: 20, enableInsets: true)
        
        heading.addAnchor(top: contentView.topAnchor, paddingTop: 10,
                          left: imgView.rightAnchor, paddingLeft: 10,
                          bottom: nil, paddingBottom: 0,
                          right: contentView.rightAnchor, paddingRight: 10,
                          width: 0, height: 0, enableInsets: true)
        
        subheading.addAnchor(top: heading.bottomAnchor, paddingTop: 8,
                             left: imgView.rightAnchor, paddingLeft: 10,
                             bottom: contentView.bottomAnchor, paddingBottom: 8,
                             right: contentView.rightAnchor, paddingRight: 10,
                             width: 0, height: 0, enableInsets: true)
        
    }

}
