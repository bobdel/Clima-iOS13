//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import os.log
import UIKit

class WeatherViewController: UIViewController {
    
    // MARK: - Properties

    var delegate: WeatherManagerDelegate?
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    // MARK: - ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        searchTextField.delegate = self // set this ViewController as the delegate for the search box
        weatherManager.delegate = self // set this VC to receive weather from JSON
    }
}

// MARK: - UITextField Delegate

extension WeatherViewController: UITextFieldDelegate {
    
    /// Handle Search button
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    
    /// Handle Go button on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    /// Do a little validation first
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            searchTextField.placeholder = "Type Something"
            return false
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        weatherManager.fetchWeather(cityName: textField.text!)
        searchTextField.text = ""
    }
}

// MARK: - WeatherManager Delegate

extension WeatherViewController: WeatherManagerDelegate {

    // note the first item in a delegate method is the name of the object that called the method
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(_ error: Error) {
        os_log("ERROR! WeatherManager Delegate %@", log: Log.general, type: .debug, #function, error.localizedDescription)
        print(error) // at this stage errors are data related so no user notification.
    }
}

