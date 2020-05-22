//
//  FirstViewController.swift
//  TabView
//
//  Created by Varma on 12/04/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
import CoreData
import AwesomeSpotlightView

class FrogListController: UIViewController, UITableViewDataSource, UITableViewDelegate, AwesomeSpotlightViewDelegate {
    
    // UI outlets
    @IBOutlet weak var showFavButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var showFavouriteFrogs: Bool = false
    // Variable to fold all the frog recored of Frog entity type
    var frogs: [FrogEntity] = []
    var favFrogs: [FrogEntity] = []
    let menuBtn = UIButton(type: .custom)
    
    var spotlightView = AwesomeSpotlightView()
    var spotlight: [SpotLightEntity] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting deligates for TabelView
        showFavButton.title = ".."
        fetchData()
        /// Reference from Stackoverflow, Author Sebastian
        /// https://stackoverflow.com/questions/25921623/how-to-reload-tableview-from-another-view-controller-in-swift
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "loadTableView"), object: nil)
        showFavButton.setBackgroundImage(UIImage(systemName: "suit.heart"), for: UIControl.State.normal, barMetrics: .default)
        setUpTableView()
        checkForSpotLight()
    }
    
    
    
    func checkForSpotLight() {
        if spotlight.isEmpty {
            CoreDataHandler.addSpotLight()
            spotlight = CoreDataHandler.fetchSpotLight()
        }
        
        if !(spotlight.first!.frogList) {
            startSpotLightTour()
        }
    }
    
    func startSpotLightTour() {
        
        // Spotlight for Image
        let spotlight1 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 13, y: 160, width: 60, height: 60), shape: .circle, text: "\nFrog's image", isAllowPassTouchesThroughSpotlight: false)
        // Spotlight for Frog's Common Name
        let spotlight2 = AwesomeSpotlight(withRect: CGRect(x: 80, y: 163, width: 130, height: 25), shape: .roundRectangle, text: "Frog's common name", isAllowPassTouchesThroughSpotlight: false)
        // Spotlight for Frog's Scentific Name
        let spotlight3 = AwesomeSpotlight(withRect: CGRect(x: 80, y: 196, width: 175, height: 25), shape: .roundRectangle, text: "Frog's scentific name", isAllowPassTouchesThroughSpotlight: false)
        // Spotlight for Filter by Favourite
        let spotlight4 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 363, y: 170, width: 40, height: 40), shape: .circle, text: "Frog's threatened status\n\nE-Endangered\nV-Vulnerable\nN-Not Endangered", isAllowPassTouchesThroughSpotlight: false)
        // Spotlight for Filter by Favourite
        let spotlight5 = AwesomeSpotlight(withRect: CGRect(x: view.frame.minY + 360, y: 40, width: 50, height: 50), shape: .circle, text: "Filter by favourite", isAllowPassTouchesThroughSpotlight: false)
        
        
        let spotlightView = AwesomeSpotlightView(frame: view.frame, spotlight: [spotlight1, spotlight2, spotlight3, spotlight4, spotlight5])
        spotlightView.cutoutRadius = 8
        spotlightView.delegate = self
        view.addSubview(spotlightView)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            spotlightView.spotlightMaskColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
            spotlightView.enableArrowDown = true
            spotlightView.start()
        }
        CoreDataHandler.updateSpotLight(attribute: "frogList", boolean: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadTable()
    }
    
    fileprivate func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        reloadTable()
    }
    
    // Gets Frogs list from CoreData
    fileprivate func fetchData() {
        //MARK: -  coreData fetch
        frogs = CoreDataHandler.fetchAllFrogs()
        favFrogs = CoreDataHandler.fetchOnlyFav()
        // If the appliation is opened for the first time then the records are added to the database
        if(frogs.count == 0) {
            CoreDataHandler.addAllRecords()
            frogs = CoreDataHandler.fetchAllFrogs()
            favFrogs = CoreDataHandler.fetchOnlyFav()
        }
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
            viewController.fromListScreen = true
            navigationController?.present(viewController, animated: true)
        }
    }
    
    // Changes the Favourite button logo up on tap
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

