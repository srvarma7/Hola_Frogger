//
//  HomeViewController.swift
//  TabView
//
//  Created by Varma on 07/05/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import iOSDropDown
import RAMReel
import Lottie

class HomeViewController: UIViewController {
    
    var namesList: [String] = []
    var selectedFrog: String = ""
    let magnitude = -20
    let animationView = AnimationView(name: "catchmeifyoucan")

    @IBOutlet weak var exploreBtn: UIButton!
    
    // set frame
    let  searchField = DropDown(frame: CGRect(x: 10, y: 0, width: 350, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var frogs: [FrogEntity] = []
        frogs = CoreDataHandler.fetchAllFrogs()
        // If the appliation is opened for the first time then the records are added to the database
        if(frogs.count == 0) {
            CoreDataHandler.addAllRecords()
            frogs = CoreDataHandler.fetchAllFrogs()
        }
        
        if namesList.count == 0 {
            for ele in frogs {
                namesList.append(ele.cname!)
            }
        }
        lottieAnimation()
        initializeSearch()
        applyParallaxEffect()
    }
    
    func lottieAnimation() {
        animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        animationView.center.x = self.view.center.x
        animationView.contentMode = .scaleAspectFit
        view.addSubview(animationView)
        animationView.loopMode = .loop
        _ = animationView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 150, heightConstant: 150)
    }
    
    func initializeSearch() {
        searchField.backgroundColor = #colorLiteral(red: 0.7719962001, green: 0.1048256829, blue: 0.2892795205, alpha: 1)
        searchField.listHeight = 150
        searchField.rowHeight = 50
        searchField.placeholder = "  Search here....."
        self.view.addSubview(searchField)
        _ = searchField.anchor(animationView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 270, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 350, heightConstant: 50)
    }
    
    func applyParallaxEffect() {
        applyMotionEffect(toView: searchField, magnitude: Float(magnitude))
        applyMotionEffect(toView: exploreBtn, magnitude: Float(-magnitude))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchField.optionArray = namesList
        searchField.rowBackgroundColor = #colorLiteral(red: 0.7719962001, green: 0.1048256829, blue: 0.2892795205, alpha: 1)
        searchField.selectedRowColor = #colorLiteral(red: 0.7719962001, green: 0.1048256829, blue: 0.2892795205, alpha: 1)
        searchField.didSelect{(selectedText , index ,id) in
            self.selectedFrog = selectedText
            print(selectedText, "SELECTED TEXT")
            self.showDetails(frogname: selectedText)
        }
        exploreBtn.layer.shadowColor = #colorLiteral(red: 0.7719962001, green: 0.1048256829, blue: 0.2892795205, alpha: 1)
        exploreBtn.layer.shadowOffset = CGSize(width: 5.0, height: 2.0)
        exploreBtn.layer.shadowOpacity = 1.0
        searchField.clipsToBounds = true
        
        // MARK:- Check here
        UIView.animate(withDuration: 1, animations: {
            self.searchField.center = self.view.center
            self.searchField.transform = CGAffineTransform(translationX: 0, y: -100)
            self.exploreBtn.layer.cornerRadius = self.exploreBtn.frame.size.width/10
            self.animationView.transform = CGAffineTransform(translationX: 0, y: 160)
            self.animationView.layer.cornerRadius = self.animationView.frame.size.width/10
            self.animationView.clipsToBounds = true
        })
        UIView.animate(withDuration: 1, animations: {
            self.searchField.layer.cornerRadius = self.searchField.frame.size.width/20
        })
        animationView.play()
    }
    
    func applyMotionEffect (toView view: DropDown, magnitude:Float) {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
    }
    
    func applyMotionEffect (toView view: UIButton, magnitude:Float) {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
    }
    
    func applyMotionEffect (toView view: UIImageView, magnitude:Float) {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        
        view.addMotionEffect(group)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func showDetails(frogname: String) {
        let singleFrog = CoreDataHandler.fetchSpecificFrog(frogname: frogname)
        print(singleFrog.sname!)
        if let viewController = storyboard?.instantiateViewController(identifier: "frogDetails") as? FrogDetailsViewController {
            viewController.receivedFrog = singleFrog
            navigationController?.present(viewController, animated: true)
        }
    }
}


////some methods for add layout constraint
//extension UIView {
//    
//    func anchorToTop(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
//        
//        anchorWithConstantsToTop(top: top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
//    }
//    
//    func anchorWithConstantsToTop(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
//        
//        translatesAutoresizingMaskIntoConstraints = false
//        
//        if let top = top {
//            topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
//        }
//        
//        if let bottom = bottom {
//            bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant).isActive = true
//        }
//        
//        if let left = left {
//            leftAnchor.constraint(equalTo: left, constant: leftConstant).isActive = true
//        }
//        
//        if let right = right {
//            rightAnchor.constraint(equalTo: right, constant: -rightConstant).isActive = true
//        }
//        
//    }
//    
//    func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
//        translatesAutoresizingMaskIntoConstraints = false
//        
//        var anchors = [NSLayoutConstraint]()
//        
//        if let top = top {
//            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
//        }
//        
//        if let left = left {
//            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
//        }
//        
//        if let bottom = bottom {
//            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
//        }
//        
//        if let right = right {
//            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
//        }
//        
//        if widthConstant > 0 {
//            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
//        }
//        
//        if heightConstant > 0 {
//            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
//        }
//        
//        anchors.forEach({$0.isActive = true})
//        
//        return anchors
//    }
//    
//    
//}
