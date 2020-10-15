//
//  WebService.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 13/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import Foundation

enum NetworkError: String, Error {
    case invalidUrl = "Invalid URL found"
    case unableToComplete = "Unable to complete the request"
    case parsingUnsuccessful = "Error while parsing"
//    case 
}

struct Resource<T: Decodable> {
    let url: URL
}

class WebService {
    
    static func getDataFromAPI<T: Decodable>(resource: Resource<T>, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        let urlLink = resource.url
        
        URLSession.shared.dataTask(with: urlLink) { data, response, error in
            if let receivedData = data, error == nil {
                do {
                    let parsedData = try JSONDecoder().decode(T.self, from: receivedData)
                    
                    DispatchQueue.main.async {
                        completion(.success(parsedData))
                    }
                    
                } catch {
                    debugPrint(error)
                }
            } else {
                completion(.failure(.invalidUrl))
            }
        }.resume()
    }
    
    //Gets image data from the API and sets the icon into image view for location's weather
    func makeGetRequestImage(icon: String){
        let url : String = "https://openweathermap.org/img/wn/" + icon + "@2x.png"
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: url) as URL?
        request.httpMethod = "GET"
        request.timeoutInterval = 60
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue(), completionHandler:{ (response:URLResponse!, data: Data!, error: Error!) -> Void in
            DispatchQueue.main.async {
//                self.wImage.backgroundColor = .clear
//                self.wImage.image = UIImage(data: data)
            }
        })
    }
    
}
