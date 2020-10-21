//
//  FrogsListVC.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 12/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit

class FrogsListVC: UIViewController {
    
    private var isShowingAllFrogs: Bool = true
    
    let filterByFavourite = UIButton(type: .custom)
    private var frogsListViewModel = FrogsListViewModel()
    var tableView = UITableView()
    
    enum CellIdentifier: String {
        case frogTVCell = "frogTVCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarButton()
        addFavouriteDidTappedObserver()
        
        // Adding tableview to the view and setup
        setupTableView()
        
    }
    
    deinit {
        debugPrint("Remove NotificationCenter Deinit in FrogsListVC")
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addFavouriteDidTappedObserver() {
        debugPrint("Adding NotificationCenter in FrogsListVC")
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "com.favourite.button.did.tapped"), object: nil)
    }
    
    private func setupNavigationBarButton() {
        filterByFavourite.setImage(UIImage(systemName: isShowingAllFrogs ? "suit.heart" : "suit.heart.fill"), for: .normal)
        filterByFavourite.addTarget(self,
                                    action: #selector(filterListByFavouriteDidTapped),
                                    for: .touchUpInside)
        filterByFavourite.tintColor = .raspberryPieTint()
        let barButtonItem = UIBarButtonItem(customView: filterByFavourite)
        
        self.navigationItem.setRightBarButtonItems([barButtonItem], animated: true)
    }
    
    @objc func filterListByFavouriteDidTapped() {
        isShowingAllFrogs.toggle()
        filterByFavourite.setImage(UIImage(systemName: isShowingAllFrogs ? "suit.heart" : "suit.heart.fill"), for: .normal)
        refresh()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        setupTableViewDelegates()        // set delegates
        tableView.rowHeight = 100        // set row height
        tableView.register(FrogTVCell.self, forCellReuseIdentifier: CellIdentifier.frogTVCell.rawValue)        // register cell
        tableView.pin(to: view)        // set constraints
        
    }
    
    @objc private func refresh() {
        frogsListViewModel.refresh()
        tableView.reloadData()
    }
}

extension FrogsListVC: UITableViewDelegate, UITableViewDataSource {
    
    private func setupTableViewDelegates() {
        tableView.delegate      = self
        tableView.dataSource    = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isShowingAllFrogs ? frogsListViewModel.allFrogsList.count : frogsListViewModel.favouriteFrogsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.frogTVCell.rawValue) as? FrogTVCell else { return UITableViewCell() }
        let frogItem = isShowingAllFrogs ? frogsListViewModel.allFrogsList[indexPath.row] : frogsListViewModel.favouriteFrogsList[indexPath.row]
        cell.frog = frogItem
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let frogDetailsVC = FrogDetailsVC()
        frogDetailsVC.frogItem = isShowingAllFrogs ? frogsListViewModel.allFrogsList[indexPath.row] : frogsListViewModel.favouriteFrogsList[indexPath.row]
        self.present(frogDetailsVC, animated: true)
    }
    
}
