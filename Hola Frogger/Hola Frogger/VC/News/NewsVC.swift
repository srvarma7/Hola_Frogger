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
        UINavigationBar.appearance().barTintColor = .systemBackground

        newsViewModel.fetchNews()
        
        setupViews()
        SpotLight.showForNews(view: view, vc: self)
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
        activityIndicator.addAnchor(top: nil, paddingTop: 0,
                                    left: nil, paddingLeft: 0,
                                    bottom: nil, paddingBottom: 0,
                                    right: nil, paddingRight: 0,
                                    width: 30, height: 30, enableInsets: true)
//
//        activityIndicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.startAnimating()
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
