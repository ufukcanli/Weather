//
//  WeatherDataManager.swift
//  Weather
//
//  Created by Ufuk Canlı on 25.12.2020.
//

import Foundation
import Alamofire

enum WeatherError: Error, LocalizedError {
    case unknown
    case invalidCity
    case unableToFindLocation
    
    var errorDescription: String? {
        switch self {
        case .invalidCity:
            return "This is an invalid city. Please try again!"
        case .unableToFindLocation:
            return "We couldn't find the current location."
        case .unknown:
            return "Hey, this is an unknown error!"
        }
    }
}

enum Constants {
    static let API_KEY = "abbc024189e935851f279b4931d3d785"
}

struct WeatherManager {
        
    func fetchWeather(byCity city: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        let endpoint = "https://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@&units=metric"
        let searchterm = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? city
        let urlString = String(format: endpoint, searchterm, Constants.API_KEY)
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: WeatherData.self, queue: .main, decoder: JSONDecoder()) { response in
            switch response.result {
            case .success(let weatherData):
                let weatherModel = weatherData.model
                completion(.success(weatherModel))
            case .failure(let error):
                if error.responseCode == 404 {
                    let invalidCityError = WeatherError.invalidCity
                    completion(.failure(invalidCityError))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        let endpoint = "https://api.openweathermap.org/data/2.5/weather?appid=%@&units=metric&lat=%f&lon=%f"
        let urlString = String(format: endpoint, Constants.API_KEY, lat, lon)
        
        AF.request(urlString)
            .validate()
            .responseDecodable(of: WeatherData.self, queue: .main, decoder: JSONDecoder()) { response in
            switch response.result {
            case .success(let weatherData):
                let weatherModel = weatherData.model
                completion(.success(weatherModel))
            case .failure(let error):
                if error.responseCode == 404 || error.responseCode == 400 {
                    let currentLocationError = WeatherError.unableToFindLocation
                    completion(.failure(currentLocationError))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
}
