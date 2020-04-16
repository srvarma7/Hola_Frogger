//
//  NewsViewController.swift
//  TabView
//
//  Created by Varma on 13/04/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit

struct JsonResponse: Codable {
    let articleCount: Int
    let articles: [Article]
}

struct Article: Codable {
    let title: String
    let description: String
    let url: String
    let image: String?
    let publishedAt: String
    let source: Source
}

struct Source: Codable {
    let name: String
    let url: String
}

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var headline: [String] = []
    
    var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getNews()
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.rowHeight = 100
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    //Fetching News from the API
    func getNews() {
        let url = URL(string: "https://gnews.io/api/v3/search?q=endangered+frog&country=au&token=2e90adf5b191d077e1ae0d79a862cbcb")
        URLSession.shared.dataTask(with: url!) { data, _, _ in
            if let data = data {
                let jsonResp = try? JSONDecoder().decode(JsonResponse.self, from: data)
                self.articles = jsonResp!.articles
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }.resume()
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = articles[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let viewController = storyboard?.instantiateViewController(identifier: "newsDetails") as? DetailsViewController {
            let article = articles[indexPath.row]
            viewController.receivedArticle = article
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}
