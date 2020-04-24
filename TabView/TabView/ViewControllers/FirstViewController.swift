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
    
    @IBOutlet weak var showFavButton: UIBarButtonItem!
    //UI outlets
    @IBOutlet weak var tableView: UITableView!
    var favCount: Int = 0
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
        //setUpMenuButton()
        showFavButton.title = ".."
        //MARK: -  coreData fetch
        frogs = CoreDataHandler.fetchObject()
        favFrogs = CoreDataHandler.fetchOnlyFav()
        // If the appliation is opened for the first time then the records are added to the database
        if(frogs.count == 0) {
            CoreDataHandler.addAllRecords()
            frogs = CoreDataHandler.fetchObject()
            favFrogs = CoreDataHandler.fetchOnlyFav()
        }
        reloadTable()
        
        // https://stackoverflow.com/questions/25921623/how-to-reload-tableview-from-another-view-controller-in-swift
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        showFavButton.setBackgroundImage(UIImage(systemName: "suit.heart"), for: UIControl.State.normal, barMetrics: .default)
        //showFavButton.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    @objc func loadList(notification: NSNotification){
        //load data here
        reloadTable()
    }
    
    func setUpMenuButton(){
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtn.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        menuBtn.setImage(UIImage(named:"suit.heart.fill"), for: .normal)
        menuBtn.addTarget(self, action: #selector(favButtonAction), for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        self.navigationItem.leftBarButtonItem = menuBarItem
    }
    
    @objc func favButtonAction(sender: UIButton!) {
        if showFavouriteFrogs {
            menuBtn.setBackgroundImage(UIImage(systemName: "suit.heart"), for: UIControl.State.normal)
        } else {
            menuBtn.setBackgroundImage(UIImage(systemName: "suit.heart.fill"), for: UIControl.State.normal)
        }
        showFavouriteFrogs.toggle()
        reloadTable()
    }
    
    func reloadTable() {
        frogs = CoreDataHandler.fetchObject()
        favFrogs = CoreDataHandler.fetchOnlyFav()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadTable()
    }
    
    //MARK: - TableView methods
    // Returns the number of frog records in the database
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showFavouriteFrogs {
            return favFrogs.count
        } else {
            return frogs.count
        }
    }
    
    // Setting the values to the cell in the TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "frogCell", for: indexPath)
    
        var newFrog: FrogEntity
        if showFavouriteFrogs {
            newFrog = favFrogs[indexPath.row]
        } else {
            newFrog = frogs[indexPath.row]
        }
        cell.textLabel?.text = newFrog.cname
        cell.detailTextLabel?.text = newFrog.sname
        if newFrog.threatnedStatus == "Not endangered" {
            cell.imageView?.image = UIImage(systemName: "n.square")
            cell.imageView?.tintColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
        } else if newFrog.threatnedStatus == "Vulnerable" {
            cell.imageView?.image = UIImage(systemName: "v.square.fill")
            cell.imageView?.tintColor = UIColor(red: 0.3, green: 0, blue: 0.7, alpha: 1)
        } else if newFrog.threatnedStatus ==  "Endangered" {
            cell.imageView?.image = UIImage(systemName: "e.square.fill")
            cell.imageView?.tintColor = UIColor(red: 0.8, green: 0, blue: 0, alpha: 0.8)
        }
        return cell
    }
    
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
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
    
    //MARK: -
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

