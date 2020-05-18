//
//  OnboardingPageCell.swift
//  TabView
//
//  Created by 李昶辰 on 13/5/20.
//  Copyright © 2020 Varma. All rights reserved.
//


import UIKit
import Lottie

class OnboardingPageCell: UICollectionViewCell {
    
    //set variable for Page
    var page: Page?{
        didSet{
            guard let page = page else {
                return
            }
            animationView.animation = Animation.named(page.animationName)
            if page.animationName == "336-search" {
                animationView.animationSpeed = 2
            } else{
                animationView.animationSpeed = 1
            }
            animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            animationView.backgroundColor = .white
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()
            
            let color = UIColor(white: 0.2, alpha: 1)
      
            
            //set format for description
            let attributedText = NSMutableAttributedString(string: page.title, attributes: [NSAttributedString.Key.font:
                UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor: color])
            
            attributedText.append(NSAttributedString(string: "\n\n\n\(page.message)", attributes: [NSAttributedString.Key.font:
                UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: color]))
            

                       
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
                       
            let length = attributedText.string.count
            attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle,
                                        range: NSRange(location: 0, length: length))
            
            textView.attributedText = attributedText
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .yellow
        iv.image = UIImage(named: "page1")
        iv.clipsToBounds = true
        return iv
    }()
    
    let animationView = AnimationView()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "Nayeon Best Beatiful"
        tv.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        tv.isEditable = false
        return tv
        
    }()
    
    let lineSeparatorView: UIView = {
           let view = UIView()
           view.backgroundColor = UIColor(white: 0.9, alpha: 1)
           return view
       }()
    
    func setupView(){
        
        addSubview(animationView)
        addSubview(textView)
        
        _ = animationView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 120, leftConstant: 39, bottomConstant: 0, rightConstant: 39, widthConstant: 335, heightConstant: 322)
        
        _ = textView.anchor(animationView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 50, leftConstant: 42, bottomConstant: 0, rightConstant: 42, widthConstant: 330, heightConstant: 180)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
}

