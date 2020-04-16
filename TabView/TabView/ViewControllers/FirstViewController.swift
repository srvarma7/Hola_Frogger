//
//  FirstViewController.swift
//  TabView
//
//  Created by Varma on 12/04/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var frogs: [FrogEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        frogs = CoreDataHandler.fetchObject()
        print(frogs.count)
        tableView.reloadData()
        
//        frogs = CoreDataHandler.fetchObject()
//        CoreDataHandler.updateFrog(frog: frogs[0], sname: "Changed", cname: "Changed", latitude: 987.08, longitude: 987.987, uncertainty: 10001, threatnedStatus: "No", isVisited: true, isFavourite: true)
        
        //MARK: - Testing coreData fetch
//        for i in frogs {
//            print(i.sname)
//        }
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "frogCell", for: indexPath)
        cell.textLabel?.text = frogs[indexPath.row].sname
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let selectedTrail = trails[indexPath.row]
        
        if let viewController = storyboard?.instantiateViewController(identifier: "frogDetails") as? FrogDetailsViewController {
            let frog = frogs[indexPath.row]
            viewController.receivedFrog = frog
            //viewController.trail = selectedTrail
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func addButton(_ sender: Any) {
        CoreDataHandler.saveFrog(sname: "sgigcfgjhgname", cname: "cname", latitude: 1213.121, longitude: 12.123, uncertainty: 123, threatnedStatus: "Danger", isVisited: false, isFavourite: false)
        frogs = CoreDataHandler.fetchObject()
        tableView.reloadData()
    }
    
    @IBAction func favButton(_ sender: Any) {
        frogs = CoreDataHandler.fetchObject()
        tableView.reloadData()
    }
}

