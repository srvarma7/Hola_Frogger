//
//  HomeVC.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 12/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    let exploreFrogsButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        #warning("Uncomment")
        setupExploreFrogsButton()
        view.backgroundColor = .white
        
    }
    
    private func setupExploreFrogsButton() {
        exploreFrogsButton.backgroundColor = .brown
        exploreFrogsButton.setTitleShadowColor(.black, for: .normal)
        exploreFrogsButton.setTitle("Explore all frogs", for: .normal)
        exploreFrogsButton.setTitleColor(.white, for: .normal)
        view.addSubview(exploreFrogsButton)
        
        exploreFrogsButton.addTarget(nil, action: #selector(exploreFrogsButtonTapped), for: .touchUpInside)
        
        setupConstraints(element: exploreFrogsButton)
    }
    
    @objc func exploreFrogsButtonTapped() {
        #warning("Replace")
//        let frogsListVC = FrogsListVC()
//        frogsListVC.title = "Explore"
//        navigationController?.pushViewController(frogsListVC, animated: true)
        #warning("till here")
        
        let frogDetails = FrogDetailsVC()
        navigationController?.pushViewController(frogDetails, animated: true)
        
    }
    
    private func setupConstraints<T: UIView>(element: T) {
        element.translatesAutoresizingMaskIntoConstraints                       = false
        element.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                         constant: 20).isActive                 = true
        element.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                         constant: -20).isActive                = true
        element.heightAnchor.constraint(equalToConstant: 150).isActive          = true
        element.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive  = true
        
    }
    

}
