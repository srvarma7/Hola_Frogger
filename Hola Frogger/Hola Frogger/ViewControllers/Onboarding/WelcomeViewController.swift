//
//  WelcomeViewController.swift
//  TabView
//
//  Created by 李昶辰 on 18/5/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import Lottie

class WelcomeViewController: UIViewController {
    
    let animationView = AnimationView(name: "catchmeifyoucan")
    let textView: UILabel = {
        let title = UILabel()
        title.text = "Hola Frogger!"
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 25)
        return title
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpAnimation()
        setConstraints()
        UIView.animate(withDuration: 2, delay: 1, animations: {
            self.textView.transform = CGAffineTransform(translationX: 0, y: 110)
        })
        navigateToNextScreen()
    }
    
    fileprivate func setUpAnimation() {
        animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        animationView.center.x = self.view.center.x
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1.5
        animationView.play(fromFrame: 20, toFrame: 300, loopMode: .loop)
        view.addSubview(textView)
        view.addSubview(animationView)
    }
    
    fileprivate func setConstraints() {
        animationView.addAnchor(top: view.topAnchor, paddingTop: 100,
                                left: view.leftAnchor, paddingLeft: 0,
                                bottom: nil, paddingBottom: 0,
                                right: view.rightAnchor, paddingRight: 0,
                                width: 150, height: 150, enableInsets: true)
        textView.addAnchor(top: animationView.bottomAnchor, paddingTop: -100,
                           left: view.leftAnchor, paddingLeft: 0,
                           bottom: nil, paddingBottom: 0,
                           right: view.rightAnchor, paddingRight: 0,
                           width: 0, height: 0, enableInsets: true)
//
//        _ = animationView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 250, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 150, heightConstant: 150)
//
//        _ = textView.anchor(animationView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: -100, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func navigateToNextScreen() {
        // Do any additional setup after loading the view.
//        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//            let sb = UIStoryboard(name: "Main", bundle: nil)
//            let infoDictionary = Bundle.main.infoDictionary
//            let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
//            //get version number
//            let userDefaults = UserDefaults.standard
//            let appVersion = userDefaults.string(forKey: "appVersion")
//            if appVersion == nil || appVersion != currentAppVersion {
//                //save the latest version number
//                userDefaults.setValue(currentAppVersion, forKey: "appVersion")
//                let homePage = sb.instantiateViewController(withIdentifier: "Guide") as! GuideViewController
//                homePage.modalPresentationStyle = .fullScreen
//                self.present(homePage, animated: true, completion: nil)
//            } else {
//                let homePage = sb.instantiateViewController(withIdentifier: "tabController") as! UITabBarController
//                homePage.modalPresentationStyle = .fullScreen
//                self.present(homePage, animated: true, completion: nil)
//            }
//        }
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            let hasLaunchedApp = AppStorage().hasLaunchedAppForFirstTime
            if !hasLaunchedApp {
                AppStorage().hasLaunchedAppForFirstTime = true
            }
            let vc = hasLaunchedApp ? TabBarView.createTabBar() : GuideViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
    }
}
