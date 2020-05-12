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
    var unSightedFrogsList: [UnSightedFrogEntity] = []
    let numberOfChallenges = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getStatistics()
    }
    
    // Fetching the Frogs details when the controller is invoked.
    func fetchData() {
        frogs = CoreDataHandler.fetchAllFrogs()
        unSightedFrogsList = CoreDataHandler.fetchAllUnsightedFrogs()
        print(unSightedFrogsList.count)
        if unSightedFrogsList.count == 0 {
            var flag = 0
            for ele in frogs {
                if flag == numberOfChallenges {
                    break
                } else {
                    if !(ele.isVisited) {
                        print(flag+1)
                        CoreDataHandler.saveFrog(entityName: "UnSightedFrogEntity", sname: ele.sname!, frogcount: Int(ele.frogcount), cname: ele.cname!, desc: ele.desc!, latitude: ele.latitude, longitude: ele.longitude, uncertainty: Int(ele.uncertainty), threatnedStatus: ele.threatnedStatus!, isVisited: ele.isVisited, isFavourite: ele.isFavourite)
                        flag += 1
                    }
                }
            }
        }
    }
    
    
    // Call this method when user marks a Frog as Visited.
    func updateSightedStatus(receivedFrog: FrogEntity, receivedUnsightedFrog: UnSightedFrogEntity, isVisited: Bool) {
        CoreDataHandler.updateFrog(frog: receivedFrog, isVisited: isVisited, isFavourite: receivedFrog.isFavourite)
        CoreDataHandler.updateUnSightedFrog(unsightedFrog: receivedUnsightedFrog, isVisited: isVisited, isFavourite: receivedUnsightedFrog.isFavourite)
        fetchData()
        getStatistics()
    }
    
    func getStatistics() {
        var sightedCount: [String] = []
        var unSightedCount: [String] = []
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
