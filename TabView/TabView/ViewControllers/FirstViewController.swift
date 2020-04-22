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
    
    //UI outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Variable to fold all the frog recored of Frog entity type
    var frogs: [FrogEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting deligates for TabelView
        tableView.delegate = self
        tableView.dataSource = self
        
        //MARK: -  coreData fetch
        frogs = CoreDataHandler.fetchObject()
        // If the appliation is opened for the first time then the records are added to the database
        if(frogs.count == 0) {
            CoreDataHandler.addAllRecords()
            frogs = CoreDataHandler.fetchObject()
        }
        // Reloads the table with all the records
        tableView.reloadData()
    }
    
    //MARK: - TableView methods
    // Returns the number of frog records in the database
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frogs.count
    }
    
    // Setting the values to the cell in the TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "frogCell", for: indexPath)
        cell.textLabel?.text = frogs[indexPath.row].sname
        return cell
    }
    
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //
        if let viewController = storyboard?.instantiateViewController(identifier: "frogDetails") as? FrogDetailsViewController {
            let frog = frogs[indexPath.row]
            viewController.receivedFrog = frog
            //viewController.trail = selectedTrail
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
    //MARK: - Testing coreData fetch
    @IBAction func favButton(_ sender: Any) {
        frogs = CoreDataHandler.fetchObject()
        tableView.reloadData()
    }
}

