//
//  OnboardingDoneCell.swift
//  TabView
//
//  Created by 李昶辰 on 13/5/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import Lottie

class OnboardingDoneCell: UICollectionViewCell {
    
   //draw the layout
    let titleTextView: UITextView = {
        let title = UITextView()
        title.text = "Almost done"
        title.textAlignment = NSTextAlignment.center
        title.font = UIFont.boldSystemFont(ofSize: 25)
        title.isEditable = false
        return title
        
    }()
    let descriptionTextView: UITextView = {
           let title = UITextView()
        title.text = "You are almost there to explore and locate Frogs around you. Click on the \"Finish\" button to go to the homescreen."
        title.textAlignment = NSTextAlignment.center
           title.font = UIFont.systemFont(ofSize: 16)
           title.isEditable = false
           return title
           
       }()
    let doneButton: UIButton = {
           let button = UIButton(type: .system)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1.0).cgColor
        button.backgroundColor = UIColor(red: 139/255, green: 195/255, blue: 74/255, alpha: 1.0)
           button.setTitle("Finish", for: .normal)
           button.setTitleColor(.white, for: .normal)
           button.addTarget(self, action: #selector(done), for: .touchDown)
           return button
       }()
    
    let reverseButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.backgroundColor = UIColor(red: 255/255, green: 180/255, blue: 183/255, alpha: 1.0)
        button.setTitle("Take the tour again", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(reversed), for: .touchDown)
        return button
    }()
    
    let reverseAnimationButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(reversed), for: .touchDown)
        return button
    }()
    var guideview: GuideViewController?
    
    @objc func done() {
        guideview?.finish()
        
    
    }
    
    var guideview1: GuideViewController?
    @objc func reversed() {
      
    }
    
    let animationView1 = AnimationView()
    let animationView2 = AnimationView()
    
    func setUpAnimation2 () {
        animationView2.animation = Animation.named("13005-refresh")
        animationView2.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        animationView2.backgroundColor = .white
        animationView2.contentMode = .scaleAspectFit
        animationView2.loopMode = .loop
        animationView2.play()
    }
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           
           setupViews()
       }
    func setupViews() {
        let screen = UIScreen.main.bounds
        animationView1.animation = Animation.named("8878-done")
        animationView1.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationView1.backgroundColor = .white
        animationView1.contentMode = .scaleAspectFit
                   animationView1.loopMode = .loop
                   animationView1.play()
        
       
        setUpAnimation2()
        addSubview(titleTextView)
        addSubview(descriptionTextView)
        addSubview(animationView1)
        addSubview(animationView2)
        addSubview(doneButton)
        addSubview(reverseButton)
        addSubview(reverseAnimationButton)
      
        //add layout constraint
        _ = animationView1.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 30,
                                  leftConstant: 41, bottomConstant: 0, rightConstant: 41, widthConstant: screen.width * 0.70, heightConstant: screen.width * 0.70)
        
        _ = doneButton.anchor(animationView1.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor,
                              topConstant: 5, leftConstant: 142, bottomConstant: 0, rightConstant: 142, widthConstant: 129, heightConstant: 48)
        
        _ = titleTextView.anchor(doneButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor,
                                 topConstant: 20, leftConstant: 73, bottomConstant: 0, rightConstant: 73, widthConstant: 268, heightConstant: 41)
       
        _ = descriptionTextView.anchor(titleTextView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor,
                                       topConstant: 5, leftConstant: 42, bottomConstant: 0, rightConstant: 42, widthConstant: 330, heightConstant: 70)
        
        _ = animationView2.anchor(descriptionTextView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor,
                                  topConstant: 10, leftConstant: 150, bottomConstant: 0, rightConstant: 150, widthConstant: 50, heightConstant: 50)
        
        _ = reverseAnimationButton.anchor(descriptionTextView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor,
                                          topConstant: 5, leftConstant: 150, bottomConstant: 0, rightConstant: 150, widthConstant: 50, heightConstant: 50)
               
         _ = reverseButton.anchor(animationView2.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor,
                                  topConstant: 16, leftConstant: 110, bottomConstant: 0, rightConstant: 110, widthConstant: 160, heightConstant: 35)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}
