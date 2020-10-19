//
//  NewsVC.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 12/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit

class NewsVC: UIViewController {
    
    private struct Cell {
        static let cellId = "cellId"
    }
    
    private var newsViewModel = NewsViewModel()
    
    private var tableView           = UITableView()
    private var activityIndicator   = UIActivityIndicatorView()
    private var refreshControl      = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsViewModel.fetchNewsDelegate = self
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        #warning("Enable fetch method after final")
//        newsViewModel.fetchNews()
        
        setupViews()
    }
    
    private func setupViews() {
        setupTableView()
        setupActivityIndicator()
        setupRefreshControl()

        addConstriants()
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.color = UIColor.raspberryPieTint()
        activityIndicator.style = .large
        activityIndicator.startAnimating()
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle  = NSAttributedString(string: "Pull to refresh")
        refreshControl.tintColor        = UIColor.raspberryPieTint()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: Any) {
        newsViewModel.fetchNews()
    }

    private func addConstriants() {
        activityIndicator.addAnchor(top: tableView.topAnchor, paddingTop: 200,
                                    left: tableView.leftAnchor, paddingLeft: 200,
                                    bottom: tableView.bottomAnchor, paddingBottom: 200,
                                    right: tableView.rightAnchor, paddingRight: 200,
                                    width: 0, height: 0, enableInsets: true)
        
    }
}

// MARK:- News fetching delegate
extension NewsVC: NewsProtocol {
    func didFinishFetchingNews() {
        tableView.reloadData()
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
    }
}

// MARK:- Table view
extension NewsVC: UITableViewDelegate, UITableViewDataSource {
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.pin(to: view)
        setupDelegates()
        tableView.register(NewsTVCell.self, forCellReuseIdentifier: Cell.cellId)
    }
    
    private func setupDelegates() {
        tableView.delegate   = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsViewModel.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: Cell.cellId) as? NewsTVCell else { return UITableViewCell() }
        cell.article    = newsViewModel.news[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArticle         = newsViewModel.news[indexPath.row]
        let detailedNewsVC          = NewsDetailedVC()
        detailedNewsVC.articleLink  = selectedArticle.url
        detailedNewsVC.title        = selectedArticle.title
        navigationController?.pushViewController(detailedNewsVC, animated: true)
    }
}
