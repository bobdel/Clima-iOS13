//
//  WeatherManager.swift
//  Clima
//
//  Created by Robert DeLaurentis on 10/31/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import CoreLocation
import Foundation
import os.log

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather/?appid=ce924c2cad4bdf2f56aadc4912248cf2&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    /// Request data via URLSession and Task
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) { //1. Create a URL
            let session = URLSession(configuration: .default) //2. Create a URLSession
            
            //3. Give the session a task, give the task a closure
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather) // passes data to WVC via delegate pattern
                    }
                }
            }
            task.resume() //4. Start the task
        }
    } // end perform request
    
    /// Parse JSON data into a WeatherModel instance
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let name = decodeData.name
            
            os_log("Success! Data Decoded %@", log: Log.general, type: .debug, #function)
            return WeatherModel(conditionID: id, cityName: name, temperature: temp)
            
        } catch {
            delegate?.didFailWithError(error)
            os_log("ERROR! Decode Fail %@ %@", log: Log.general, type: .debug, #function, error.localizedDescription)
            return nil
        }
    }
}



