//
//  WeatherData.swift
//  Weather
//
//  Created by Ufuk Canlı on 25.12.2020.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
}
