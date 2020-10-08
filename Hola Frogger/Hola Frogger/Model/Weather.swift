//
//  Weather.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 8/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

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
