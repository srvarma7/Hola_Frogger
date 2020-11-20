//
//  FrogsListVC.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 12/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit

class FrogsListVC: UIViewController {
    
    private var isShowingAllFrogs: Bool = false
    
    let filterByFavourite = UIButton(type: .custom)
    private var frogsListViewModel = FrogsListViewModel()
    var tableView = UITableView()
    private var guideLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines     = 0
        label.textAlignment     = .center
        label.backgroundColor   = .systemBackground
        let attributeText = NSMutableAttributedString(string: "No favourite frogs to show",
                                                      attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
                                                                   NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue])
        let body1 = NSAttributedString(string: "\n\nClick on heart icon (",
                                       attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
        let icon  = NSTextAttachment()
        icon.image = UIImage(systemName: "suit.heart")?.withTintColor(.raspberryPieTint(), renderingMode: .alwaysOriginal)
        
        let body2 = NSAttributedString(string: ") in frog's details screen to make favourite/unfavourite",
                                                             attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
        
        attributeText.append(body1)
        attributeText.append(NSAttributedString(attachment: icon))
        attributeText.append(body2)
        label.attributedText = attributeText
        label.textColor = .raspberryPieTint()
        
        return label
    }()

    enum CellIdentifier: String {
        case frogTVCell = "frogTVCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarButton()
        addFavouriteDidTappedObserver()
        
        // Adding views to the VC and configuring
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SpotLight.showForExplore(view: view, vc: self)
    }
    
    deinit {
        debugPrint("Remove NotificationCenter Deinit in FrogsListVC")
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addFavouriteDidTappedObserver() {
        debugPrint("Adding NotificationCenter in FrogsListVC")
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshTableView),
                                               name: NSNotification.Name(rawValue: "com.favourite.button.did.tapped"),
                                               object: nil)
    }
    
    private func setupNavigationBarButton() {
        filterByFavourite.setImage(UIImage(systemName: isShowingAllFrogs ? "suit.heart.fill" : "suit.heart"),
                                   for: .normal)
        filterByFavourite.addTarget(self,
                                    action: #selector(filterListByFavouriteDidTapped),
                                    for: .touchUpInside)
        filterByFavourite.tintColor = .raspberryPieTint()
        let barButtonItem = UIBarButtonItem(customView: filterByFavourite)
        
        self.navigationItem.setRightBarButtonItems([barButtonItem], animated: true)
    }
    
    @objc func filterListByFavouriteDidTapped() {
        isShowingAllFrogs.toggle()
        print(isShowingAllFrogs)
        filterByFavourite.setImage(UIImage(systemName: isShowingAllFrogs ? "suit.heart.fill" : "suit.heart"), for: .normal)
        if checkForFrogsPresentInFavourite() {
            refreshTableView()
        }
    }
    
    private func checkForFrogsPresentInFavourite() -> Bool {
        if frogsListViewModel.favouriteFrogsList.count == 0 && isShowingAllFrogs {
            tableView.isHidden = true
            guideLabel.isHidden = false
            return false
        } else {
            tableView.isHidden = false
            guideLabel.isHidden = true
            return true
        }
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        
        setupTableViewDelegates()        // set delegates
        tableView.rowHeight = 100        // set row height
        tableView.register(FrogTVCell.self, forCellReuseIdentifier: CellIdentifier.frogTVCell.rawValue)        // register cell
        tableView.pin(to: view)          // set constraints
        
        view.addSubview(guideLabel)
        guideLabel.pin(to: view)
        guideLabel.isHidden = true
    }
    
    @objc private func refreshTableView() {
        frogsListViewModel.refresh()
        _ = checkForFrogsPresentInFavourite()
        tableView.reloadData()
    }
}

extension FrogsListVC: UITableViewDelegate, UITableViewDataSource {
    
    private func setupTableViewDelegates() {
        tableView.delegate      = self
        tableView.dataSource    = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !isShowingAllFrogs ? frogsListViewModel.allFrogsList.count : frogsListViewModel.favouriteFrogsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.frogTVCell.rawValue) as? FrogTVCell else { return UITableViewCell() }
        let frogItem = !isShowingAllFrogs ? frogsListViewModel.allFrogsList[indexPath.row] : frogsListViewModel.favouriteFrogsList[indexPath.row]
        cell.frog = frogItem
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let frogDetailsVC = FrogDetailsVC()
        frogDetailsVC.frogItem = !isShowingAllFrogs ? frogsListViewModel.allFrogsList[indexPath.row] : frogsListViewModel.favouriteFrogsList[indexPath.row]
        self.present(frogDetailsVC, animated: true)
    }
}
