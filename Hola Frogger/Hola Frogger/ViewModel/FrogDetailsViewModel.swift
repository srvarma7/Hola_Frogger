//
//  FrogDetailsViewModel.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 15/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import Foundation

class FrogDetailsViewModel {
   
    var weather: WeatherJsonResponse?
    var imageData: Data?
    
    var weatherDelegate: WeatherProtocol?
    
    func fetchWeatherDetailsFor(latitude: String, longitude: String) {
        
        let resource = WeatherJsonResponse.urlFor(latitude: latitude, longitude: longitude)
        WebService.getDataFromAPI(resource: resource, completion: { [weak self]  result in
            switch result {
                case .failure(let error):
                    print(error)
                    
            case .success(let data):
                self?.weather = data
                self?.getWeatherIcon(iconName: (data?.weather[0].icon)!)
                self?.weatherDelegate?.didFinishFetchingWeather()
            }
        })
    }
    
    private func getWeatherIcon(iconName: String) {
        WebService.getImage(icon: iconName, completion: { result in
            switch result {
            case .success(let data):
                self.imageData = data
                self.weatherDelegate?.didFinishFetchingWeatherIcon()
            case .failure(let error):
                print("Failure", error)
                
            }
        })
    }
    
}
