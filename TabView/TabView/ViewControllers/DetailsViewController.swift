//
//  DetailsViewController.swift
//  TabView
//
//  Created by Varma on 14/04/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var receivedArticle: Article?
    
    @IBOutlet weak var textLabel: UITextView!
    @IBOutlet weak var descLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textLabel.text = receivedArticle!.title
        descLabel.text = receivedArticle!.description
        // Do any additional setup after loading the view.
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
