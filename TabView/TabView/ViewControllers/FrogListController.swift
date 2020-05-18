//
//  FirstViewController.swift
//  TabView
//
//  Created by Varma on 12/04/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import CoreData

class FrogListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // UI outlets
    @IBOutlet weak var showFavButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var showFavouriteFrogs: Bool = false
    // Variable to fold all the frog recored of Frog entity type
    var frogs: [FrogEntity] = []
    var favFrogs: [FrogEntity] = []
    let menuBtn = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting deligates for TabelView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        showFavButton.title = ".."
        
        //MARK: -  coreData fetch
        frogs = CoreDataHandler.fetchAllFrogs()
        favFrogs = CoreDataHandler.fetchOnlyFav()
        // If the appliation is opened for the first time then the records are added to the database
        if(frogs.count == 0) {
            CoreDataHandler.addAllRecords()
            frogs = CoreDataHandler.fetchAllFrogs()
            favFrogs = CoreDataHandler.fetchOnlyFav()
        }
        reloadTable()
        /// Reference from Stackoverflow, Author Sebastian
        /// https://stackoverflow.com/questions/25921623/how-to-reload-tableview-from-another-view-controller-in-swift
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        showFavButton.setBackgroundImage(UIImage(systemName: "suit.heart"), for: UIControl.State.normal, barMetrics: .default)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadTable()
    }
    
    // Whenever this controller recieves notification, table view is refreshed.
    @objc func loadList(notification: NSNotification){
        /// load data here
        reloadTable()
    }
    
    // Action function when the Favouite button is tapped.
    @objc func favButtonAction(sender: UIButton!) {
        if showFavouriteFrogs {
            menuBtn.setBackgroundImage(UIImage(systemName: "suit.heart"), for: UIControl.State.normal)
        } else {
            menuBtn.setBackgroundImage(UIImage(systemName: "suit.heart.fill"), for: UIControl.State.normal)
        }
        showFavouriteFrogs.toggle()
        reloadTable()
    }
    
    // Fetched the latest data from database and reloads the table view
    func reloadTable() {
        frogs = CoreDataHandler.fetchAllFrogs()
        favFrogs = CoreDataHandler.fetchOnlyFav()
        tableView.reloadData()
    }
    
    //MARK: - TableView methods
    // Returns the number of frog records in the Lists
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showFavouriteFrogs {
            return favFrogs.count
        } else {
            return frogs.count
        }
    }
    
    // Setting the values to the cell in the TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "frogCell", for: indexPath) as! FrogCell
    
        var newFrog: FrogEntity
        if showFavouriteFrogs {
            newFrog = favFrogs[indexPath.row]
        } else {
            newFrog = frogs[indexPath.row]
        }
        
        cell.cName.text = newFrog.cname
        cell.sName.text = newFrog.sname
        if newFrog.sname == "Litoria paraewingi" {
            cell.frogImage.image = UIImage(named: "frogsplash")
            cell.frogImage.image = UIImage(named: newFrog.sname!)
        } else {
            cell.frogImage.image = UIImage(named: newFrog.sname!)
        }        
        if newFrog.threatnedStatus == "Not endangered" {
            cell.status.image = UIImage(systemName: "n.square")
            cell.status.tintColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
        } else if newFrog.threatnedStatus == "Vulnerable" {
            cell.status.image = UIImage(systemName: "v.square.fill")
            cell.status.tintColor = UIColor(red: 0.3, green: 0, blue: 0.7, alpha: 1)
        } else if newFrog.threatnedStatus ==  "Endangered" {
            cell.status.image = UIImage(systemName: "e.square.fill")
            cell.status.tintColor = UIColor(red: 0.8, green: 0, blue: 0, alpha: 0.8)
        }
        return cell
    }
    
    // When tapped on a particular row, this method is invoked and redirected to Frog details controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = storyboard?.instantiateViewController(identifier: "frogDetails") as? FrogDetailsViewController {
            var newFrog: FrogEntity
            if showFavouriteFrogs {
                newFrog = favFrogs[indexPath.row]
            } else {
                newFrog = frogs[indexPath.row]
            }
            let frog = newFrog
            viewController.receivedFrog = frog
            navigationController?.present(viewController, animated: true)
        }
    }
    
    //MARK: - Changes the Favourite button logo up on tap
    @IBAction func favButton(_ sender: Any) {
        if showFavouriteFrogs {
            showFavButton.setBackgroundImage(UIImage(systemName: "suit.heart"), for: UIControl.State.normal, barMetrics: .default)
        } else {
            showFavButton.setBackgroundImage(UIImage(systemName: "suit.heart.fill"), for: UIControl.State.normal, barMetrics: .default)
        }
        showFavouriteFrogs.toggle()
        reloadTable()
    }
}

