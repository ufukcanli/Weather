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
    
    var errorDescription: String? {
        switch self {
        case .invalidCity:
            return "This is an invalid city. Please try again!"
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
        
        AF.request(urlString).responseDecodable(of: WeatherData.self, queue: .main, decoder: JSONDecoder()) { response in
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
}
