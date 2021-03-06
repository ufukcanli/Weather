//
//  ViewController.swift
//  Weather
//
//  Created by Ufuk Canlı on 25.12.2020.
//

import UIKit
import SkeletonView
import CoreLocation

protocol WeatherViewControllerDelegate: AnyObject {
    func didUpdateWeatherFromSearch(withModel model: WeatherModel)
}

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    private let weatherManager = WeatherManager()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddCity" {
            if let destination = segue.destination as? SearchCityViewController {
                destination.delegate = self
            }
        }
    }

    @IBAction func searchCityButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showSearchCity", sender: nil)
    }
    
    @IBAction func locationButtonTapped(_ sender: UIBarButtonItem) {
        locationManagerDidChangeAuthorization(locationManager)
    }
    
    private func showAlertForLocationPermission() {
        let alertController = UIAlertController(title: "Requires Location Permission", message: "Would you like to enable location permission in Settings?", preferredStyle: .alert)
        
        let enableAction = UIAlertAction(title: "Go To Settings", style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
        alertController.addAction(enableAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
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

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        case .restricted, .denied:
            showAlertForLocationPermission()
        @unknown default:
            fatalError("Unknown error when asking for location permissions.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            manager.stopUpdatingLocation()
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            weatherManager.fetchWeather(lat: latitude, lon: longitude) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let weatherModel):
                    self.updateView(withModel: weatherModel)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
