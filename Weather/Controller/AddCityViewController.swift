//
//  AddCityViewController.swift
//  Weather
//
//  Created by Ufuk Canlı on 25.12.2020.
//

import UIKit

class AddCityViewController: UIViewController {
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    
    weak var delegate: WeatherViewControllerDelegate?
    
    private let weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cityTextField.becomeFirstResponder()
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        statusLabel.isHidden = true
        guard let query = cityTextField.text, !query.isEmpty else { return }
        handleSearch(query: query)
        handleSearchError(text: "City cannot be empty. Please try again!")
    }

    private func handleSearch(query: String) {
        activityIndicator.startAnimating()
        weatherManager.fetchWeather(byCity: query) { [weak self] result in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            switch result {
            case .success(let weatherModel):
                self.handleSearchSuccess(weatherModel: weatherModel)
            case .failure(let error):
                self.handleSearchError(text: error.localizedDescription)
            }
        }
    }
    
    private func handleSearchSuccess(weatherModel: WeatherModel) {
        statusLabel.isHidden = false
        statusLabel.textColor = .systemGreen
        statusLabel.text = "Success!"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.delegate?.didUpdateWeatherFromSearch(withModel: weatherModel)
        }
        view.endEditing(true)
        cityTextField.resignFirstResponder()
    }
    
    private func handleSearchError(text: String) {
        statusLabel.isHidden = false
        statusLabel.textColor = .systemRed
        statusLabel.text = text
    }
    
    private func configureViewController() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)

        view.backgroundColor = UIColor.init(white: 0.3, alpha: 0.4)
        
        cityTextField.delegate = self
        statusLabel.isHidden = true
    }

}

extension AddCityViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self.view
    }
}

extension AddCityViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        statusLabel.isHidden = true
        guard let query = cityTextField.text, !query.isEmpty else { return false }
        handleSearch(query: query)
        handleSearchError(text: "City cannot be empty. Please try again!")
        return true
    }
}
