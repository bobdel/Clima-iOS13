//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import CoreLocation
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
    
    var locationManager = CLLocationManager()
    
    // MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // delegate declarations
        searchTextField.delegate = self // set this ViewController as the delegate for the search box
        weatherManager.delegate = self // set this VC to receive weather from JSON
        locationManager.delegate = self // must be set before the next two methods are called!
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
}



// MARK: - UITextFieldDelegate

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
        weatherManager.fetchWeather(city: textField.text!)
        searchTextField.text = ""
    }
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {

    // note the first item in a delegate method is the name of the object that called the method
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(_ error: Error) {
        os_log("ERROR! WeatherManager Delegate %@", log: Log.general, type: .error, #function, error.localizedDescription)
        print(error) // at this stage errors are data related so no user notification.
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        os_log("Success! Location Manager Delegate %@", log: Log.general, type: .info, #function)
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        os_log("ERROR! WeatherManager Delegate %@", log: Log.general, type: .error, #function, error.localizedDescription)
    }
        
    /// Handle Current Location Button. This also triggers didUpdateLocations method above
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }

}
