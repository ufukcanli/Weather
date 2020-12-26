//
//  ViewController.swift
//  Weather
//
//  Created by Ufuk Canlı on 25.12.2020.
//

import UIKit
import SkeletonView

protocol WeatherViewControllerDelegate: AnyObject {
    func didUpdateWeatherFromSearch(withModel model: WeatherModel)
}

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    private let weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAnimation()
        
        weatherManager.fetchWeather(byCity: "Istanbul") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weatherModel):
                self.updateView(withModel: weatherModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddCity" {
            if let destination = segue.destination as? AddCityViewController {
                destination.delegate = self
            }
        }
    }

    @IBAction func addCityButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showAddCity", sender: nil)
    }
    
    @IBAction func locationButtonTapped(_ sender: UIBarButtonItem) {
        
    }
        
    private func updateView(withModel model: WeatherModel) {
        hideAnimation()
        
        temperatureLabel.text = "\(model.temp)°C"
        conditionLabel.text = model.conditionDescription
        conditionImageView.image = UIImage(named: model.conditionImage)
        navigationItem.title = model.countryName
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

extension WeatherViewController: WeatherViewControllerDelegate {
    
    func didUpdateWeatherFromSearch(withModel model: WeatherModel) {
        presentedViewController?.dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.updateView(withModel: model)
        })
    }
}
