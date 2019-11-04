//
//  WeatherManager.swift
//  Clima
//
//  Created by Robert DeLaurentis on 10/31/19.
//  Copyright © 2019 Robert DeLaurentis. All rights reserved.
//

import CoreLocation
import Foundation
import os.log

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?

    func fetchWeather(city: String) {
        let urlString = createQueryURL(queryItems: [
            URLQueryItem(name: Constants.cityName, value: city)
            ]
        )
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = createQueryURL(queryItems: [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)")
            ]
        )
        performRequest(with: urlString)
    }
        
    /// Create a URL
    func createQueryURL(queryItems: [URLQueryItem]) -> String {
        
        var components = URLComponents()
        
        components.scheme = Constants.apiScheme
        components.host = Constants.apiHost
        components.path = Constants.apiPath
        
        let baseItems = [
            URLQueryItem(name: Constants.apiKeyName, value: Constants.apiKey),
            URLQueryItem(name: Constants.apiUnitsName, value: Constants.apiUnits)
            ]
        
        components.queryItems = baseItems + queryItems
    
        return components.url!.absoluteString
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
            
            os_log("Success! Data Decoded %@", log: Log.general, type: .info, #function)
            return WeatherModel(conditionID: id, cityName: name, temperature: temp)
            
        } catch {
            delegate?.didFailWithError(error)
            os_log("ERROR! Decode Fail %@ %@", log: Log.general, type: .info, #function, error.localizedDescription)
            return nil
        }
    }
}



