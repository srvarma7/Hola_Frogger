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
        let screen = view.bounds
        animationView.addAnchor(top: view.topAnchor, paddingTop: (screen.height * 0.4) - 150,
                                left: view.leftAnchor, paddingLeft: 0,
                                bottom: nil, paddingBottom: 0,
                                right: view.rightAnchor, paddingRight: 0,
                                width: 0, height: 150, enableInsets: true)
        
        textView.addAnchor(top: animationView.topAnchor, paddingTop: 50,
                           left: view.leftAnchor, paddingLeft: 0,
                           bottom: nil, paddingBottom: 0,
                           right: view.rightAnchor, paddingRight: 0,
                           width: 0, height: 0, enableInsets: true)
    }
    
    fileprivate func navigateToNextScreen() {
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let hasLaunchedApp = AppStorage.hasLaunchedAppForFirstTime
            if !hasLaunchedApp {
                AppStorage.hasLaunchedAppForFirstTime = true
            }
            let vc = hasLaunchedApp ? TabBarView.createTabBar() : GuideViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
    }
}
