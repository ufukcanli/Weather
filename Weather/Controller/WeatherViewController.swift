//
//  ViewController.swift
//  Weather
//
//  Created by Ufuk Canlı on 25.12.2020.
//

import UIKit
import SkeletonView

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    private let weatherDataManager = WeatherDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAnimation()
        
        weatherDataManager.fetchWeather(byCity: "Istanbul") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weatherData):
                self.updateView(with: weatherData)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    @IBAction func addCityButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showAddCity", sender: nil)
    }
    
    @IBAction func locationButtonTapped(_ sender: UIBarButtonItem) {
        
    }
        
    private func updateView(with data: WeatherData) {
        hideAnimation()
        
        temperatureLabel.text = String(format: "%.f", data.main.temp) + "°C"
        conditionLabel.text = data.weather.first?.description
        navigationItem.title = data.name
    }
    
    private func showAnimation() {
        conditionImageView.showAnimatedGradientSkeleton()
        temperatureLabel.showAnimatedGradientSkeleton()
        conditionLabel.showAnimatedGradientSkeleton()
    }
    
    private func hideAnimation() {
        conditionImageView.hideSkeleton()
        temperatureLabel.hideSkeleton()
        conditionLabel.hideSkeleton()
    }
}

