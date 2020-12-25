//
//  WeatherDataManager.swift
//  Weather
//
//  Created by Ufuk Canlı on 25.12.2020.
//

import Foundation
import Alamofire

struct WeatherDataManager {
        
    func fetchWeather(byCity city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        let endpoint = "https://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@&units=metric"
        let searchterm = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? city
        let urlString = String(format: endpoint, searchterm, Constants.API_KEY)
        
        AF.request(urlString).responseDecodable(of: WeatherData.self, queue: .main, decoder: JSONDecoder()) { response in
            switch response.result {
            case .success(let weatherData):
                completion(.success(weatherData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
