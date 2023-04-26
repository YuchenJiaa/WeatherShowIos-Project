//
//  WeatherData.swift
//  WeatherShow
//
//  Created by 贾贾 on 2023/4/25.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
