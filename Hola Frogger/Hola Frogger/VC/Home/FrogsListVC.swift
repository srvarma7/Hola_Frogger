//
//  FrogsListVC.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 12/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit

class FrogsListVC: UIViewController {
    
    private var frogsListViewModel = FrogsListViewModel()
    var tableView = UITableView()

    enum CellIdentifier: String {
        case frogTVCell = "frogTVCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
        // Adding tableview to the view and setup
        setupTableView()
        
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        setupTableViewDelegates()        // set delegates
        tableView.rowHeight = 100        // set row height
        tableView.register(FrogTVCell.self, forCellReuseIdentifier: CellIdentifier.frogTVCell.rawValue)        // register cell
        tableView.pin(to: view)        // set constraints
        
    }
    
    
}

extension FrogsListVC: UITableViewDelegate, UITableViewDataSource {
    
    private func setupTableViewDelegates() {
        tableView.delegate      = self
        tableView.dataSource    = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frogsListViewModel.frogsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.frogTVCell.rawValue) as? FrogTVCell else { return UITableViewCell() }
        let frogItem = frogsListViewModel.frogsList[indexPath.row]
        cell.frog = frogItem
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let frogDetails = FrogDetailsVC()
        frogDetails.frogItem = frogsListViewModel.frogsList[indexPath.row]
        self.present(frogDetails, animated: true)
    }
    
}
