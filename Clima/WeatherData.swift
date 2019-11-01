//
//  WeatherData.swift
//  Clima
//
//  Created by Robert DeLaurentis on 11/1/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    
    struct Main: Decodable {
        let temp: Double
    }

    struct Weather: Decodable {
        let description: String
    }

}

