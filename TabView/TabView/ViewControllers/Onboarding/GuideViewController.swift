//
//  GuideViewController.swift
//  TabView
//
//  Created by 李昶辰 on 13/5/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
 
    
    
    //add the collectionView
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //change left to right
        layout.scrollDirection = .horizontal
        //no space between the page
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        //like page swipe
        cv.isPagingEnabled = true
        return cv
    }()
    
    let cellId = "cellId"
    let fileId = "fileId"
    
    let pages: [Page] = {
        let firstPage = Page(title: "Search", message: "Search for your favourite frogs using both scientific or common names. Get live suggestion based on your text!", animationName: "336-search")
        let secondPage = Page(title: "Frog Names", message: "Our application provides both scientific as well as common names for you to recognize your favourite frog. We have carefully laid out colour-coded icons(V - Vulnerable, E - Endangered, N - Non - Vulnerable) to highlight the species based on their population.", animationName: "10548-forest")
        let thirdPage = Page(title: "Identify", message: "Hola Frogger is equipped with lens feature to identify a frog species and provide the correct name for frog through our self machine-learned data. Just point to the Frog and Magic!!", animationName: "291-searchask-loop")
        let fourthPage = Page(title: "Locate Frog on Maps", message: "Our data provides hotspot across Victoria to sight particular frog species. Just find the annotation on the map, along with our correct weather information will give you an edge of sighting the frog in wild.", animationName: "13357-route-finder")
        let fifthPage = Page(title: "News", message: "Stay up-to date with latest news on frogs from multiple trusted sources across the web. Just curated for your need.", animationName: "20301-newspaper-open")
        return [firstPage, secondPage, thirdPage,fourthPage,fifthPage]
        
    }()
    
    //add pageControl
    let pageControl: UIPageControl = {
        let pc = UIPageControl();
        pc.pageIndicatorTintColor = .lightGray
        //point color
        pc.currentPageIndicatorTintColor = UIColor(red: 139/255, green: 195/255, blue: 74/255, alpha: 0.78)
        pc.numberOfPages = 5
        return pc
    }()
    
    //add button
    let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(skip), for: .touchDown)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        //button.setImage(UIImage(named: "right"), for: .normal)
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return button
    }()
    
    lazy var preButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        //button.setImage(UIImage(named: "left"), for: .normal)
        button.addTarget(self, action: #selector(lastPage), for: .touchUpInside)
        return button
    }()
    
    //method for skip button
    @objc func skip() {
        pageControl.currentPage = pages.count - 1
        nextPage()
    }
    
    //method for prebutton
    @objc func lastPage(){
        if pageControl.currentPage == pages.count {
            return
        }
        if pageControl.currentPage == 1{
            moveLeftbutton()
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                           self.view.layoutIfNeeded()
                       }, completion: nil)
            
            
        }
        let indexPath = IndexPath(item: pageControl.currentPage - 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage -= 1
        
        
    }
        
    //method for nextButton
    @objc func nextPage() {
        //we are on the last page
        if pageControl.currentPage == pages.count {
            return
        }
        preButtonTopAnchor?.constant = 0
        //second last page
     if pageControl.currentPage == pages.count - 1 {
           moveControlConstraintsOffScreen()
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
       
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1
    }
    
    //set constraint
    var pageControlBottomAnchor: NSLayoutConstraint?
    var skipButtonTopAnchor: NSLayoutConstraint?
    var nextButtonTopAnchor: NSLayoutConstraint?
    var preButtonTopAnchor: NSLayoutConstraint?

    //method for animation skip, nextbutton,prebutton
    fileprivate func moveControlConstraintsOffScreen() {
           pageControlBottomAnchor?.constant = 80
           skipButtonTopAnchor?.constant = -100
           nextButtonTopAnchor?.constant = 500
            preButtonTopAnchor?.constant = -80
       }
    
    fileprivate func moveLeftbutton(){
         preButtonTopAnchor?.constant = -80
        
    }
    
    //method for reversed button
    @objc func reversed() {
        let indexPath = IndexPath(item: pageControl.currentPage - 5, section: 0)
         collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage -= 5
        pageControlBottomAnchor?.constant = -60
        skipButtonTopAnchor?.constant = 0
        nextButtonTopAnchor?.constant = -60
    }
    
    //method for done button
    @objc func done() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let homePage = sb.instantiateViewController(withIdentifier: "tabController") as! UITabBarController
        
        homePage.modalPresentationStyle = .fullScreen
        self.present(homePage, animated: true, completion: nil)
    
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //remain light system
        self.overrideUserInterfaceStyle = .light
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        view.addSubview(preButton)
        
        //add layout constraint
        pageControlBottomAnchor = pageControl.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 60, rightConstant: 0, widthConstant: 0, heightConstant: 60)[1]
        
        skipButtonTopAnchor = skipButton.anchor(view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0 , bottomConstant: 0, rightConstant: 20, widthConstant: 80, heightConstant: 60).first
        preButtonTopAnchor = preButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 30, bottomConstant: 60, rightConstant: 0, widthConstant: 80, heightConstant: 60).first
        preButtonTopAnchor?.constant = -80
        
        nextButtonTopAnchor = nextButton.anchor(nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 60, rightConstant: 0, widthConstant: 80, heightConstant: 60).first
        
        //use autolayout instead
        collectionView.anchorToTop(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        registerCells()
        
    }
    
    fileprivate func registerCells() {
           collectionView.register(OnboardingPageCell.self, forCellWithReuseIdentifier: cellId)
           collectionView.register(OnboardingDoneCell.self, forCellWithReuseIdentifier: fileId)
       }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    //method for scroll page
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        //we are on the last page
              if pageNumber == pages.count {
                  moveControlConstraintsOffScreen()
              }
              else if pageNumber == 0{
                pageControlBottomAnchor?.constant = -60
                skipButtonTopAnchor?.constant = 0
                nextButtonTopAnchor?.constant = -60
                preButtonTopAnchor?.constant = -80
              }
              else {
                  //back on regular pages
                  pageControlBottomAnchor?.constant = -60
                  skipButtonTopAnchor?.constant = 0
                  nextButtonTopAnchor?.constant = -60
                  preButtonTopAnchor?.constant = 0
              }
              
              UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                  self.view.layoutIfNeeded()
                  }, completion: nil)
        
        
    }
    
    //add two cells for page
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if indexPath.item == pages.count {
            let fileCell = collectionView.dequeueReusableCell(withReuseIdentifier: fileId, for: indexPath)
            return fileCell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! OnboardingPageCell
        
       // let page = pages[indexPath.item]
        let page = pages[(indexPath as NSIndexPath).item]
        cell.page = page
        
        return cell
    }
    
    func finish(){
        
          let indexPath = IndexPath(item: pageControl.currentPage - 5, section: 0)
               collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally,animated: true)
               pageControl.currentPage -= 5
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }

}

// methods for add layout constraint
extension UIView {
    
    func anchorToTop(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
        
        anchorWithConstantsToTop(top: top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    func anchorWithConstantsToTop(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: leftConstant).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -rightConstant).isActive = true
        }
        
    }
    
    func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
    
}

