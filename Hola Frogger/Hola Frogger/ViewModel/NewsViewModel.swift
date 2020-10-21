//
//  NewsViewModel.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 13/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import Foundation

class NewsViewModel {
    
    var news: [Article]
    var fetchNewsDelegate: NewsProtocol?
    
    init() {
        news = [Article]()
    }
    
    func fetchNews() {
        WebService.getDataFromAPI(resource: NewsJsonResponse.all, completion: { [weak self] parsedData in
            switch parsedData {
                case .success(let data):    self?.news = data!.articles
                    self?.fetchNewsDelegate?.didFinishFetchingNews()
                case .failure(let error):   print("Error -> ", error)
            }
        })
        
    }
    
    
}
