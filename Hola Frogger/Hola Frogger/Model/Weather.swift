//
//  Weather.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 8/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//
import Foundation

// Structure to hold API response
struct WeatherJsonResponse: Codable {
    let name: String
    let id: Int
    let weather: [Weather]
    let main: TempPressure
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct TempPressure: Codable {
    let temp: Double
    let pressure: Double
    let humidity: Int
}

extension WeatherJsonResponse {
    
    static func urlFor(latitude: String, longitude: String) -> Resource<WeatherJsonResponse> {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=3af463d5d4d7916e155dd605e37db688")!
        return Resource(url: url)
    }
    
//    static var all: Resource<WeatherJsonResponse> = {
//        let url = URL(string: "https://gnews.io/api/v3/search?q=endangered+frog&country=au&token=2e90adf5b191d077e1ae0d79a862cbcb")!
//        return Resource(url: url)
//    }()
}
