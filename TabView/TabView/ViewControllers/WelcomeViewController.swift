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
    let textView: UITextView = {
            let title = UITextView()
            title.text = "Welcome Hola Frogger!"
            title.textAlignment = NSTextAlignment.center
            title.font = UIFont.boldSystemFont(ofSize: 20)
            title.isEditable = false
            return title
            
        }()
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        animationView.center.x = self.view.center.x
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
        view.addSubview(textView)
        
        _ = animationView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 250, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 150, heightConstant: 150)
        
        _ = textView.anchor(animationView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 150, heightConstant: 150)
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now()+6) {
                
                let sb = UIStoryboard(name: "Main", bundle: nil)
                 let infoDictionary = Bundle.main.infoDictionary
                let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
                             
                         //get version number
                let userDefaults = UserDefaults.standard
                let appVersion = userDefaults.string(forKey: "appVersion")
                             
                if appVersion == nil || appVersion != currentAppVersion {
                             //save the latest version number
                    userDefaults.setValue(currentAppVersion, forKey: "appVersion")
                    
                    let homePage = sb.instantiateViewController(withIdentifier: "Guide") as! GuideViewController
                    homePage.modalPresentationStyle = .fullScreen
                    self.present(homePage, animated: true, completion: nil)
                }
                else{
                    let homePage = sb.instantiateViewController(withIdentifier: "tabController") as! UITabBarController
                    homePage.modalPresentationStyle = .fullScreen
                    self.present(homePage, animated: true, completion: nil)
            }
             }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
