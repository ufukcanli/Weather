//
//  ViewController.swift
//  Weather
//
//  Created by Ufuk Canlı on 25.12.2020.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    private let weatherDataManager = WeatherDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherDataManager.fetchWeather(city: "Istanbul")
    }

    @IBAction func addLocationButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func locationButtonTapped(_ sender: UIBarButtonItem) {
        
    }
}

