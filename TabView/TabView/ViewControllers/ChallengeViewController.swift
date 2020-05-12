//
//  ChallengeViewController.swift
//  TabView
//
//  Created by Varma on 12/05/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController {

    @IBOutlet weak var sightedLabel: UILabel!
    @IBOutlet weak var unSightedLabel: UILabel!
    var frogs: [FrogEntity] = []
    var sightedCount: [String] = []
    var unSightedCount: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        frogs = CoreDataHandler.fetchObject()
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getStatistics()
    }
    
    func getStatistics() {
        sightedCount.removeAll()
        unSightedCount.removeAll()
        for ele in frogs {
            if ele.isVisited {
                sightedCount.append(ele.sname!)
            } else {
                unSightedCount.append(ele.sname!)
            }
        }
        sightedLabel.text = String(sightedCount.count)
        unSightedLabel.text = String(unSightedCount.count)
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
