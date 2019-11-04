//
//  OWMConstants.swift
//  Clima
//
//  Created by Robert DeLaurentis on 11/4/19.
//  Copyright © 2019 Robert DeLaurentis. All rights reserved.
//

import Foundation

extension WeatherManager {
    
    struct Constants {
        
        // MARK: API Key
        static let apiKey = "ce924c2cad4bdf2f56aadc4912248cf2"
        
        // MARK: URLs
        static let apiScheme = "https"
        static let apiHost = "api.openweathermap.org"
        static let apiPath = "/data/2.5/weather/"
        static let apiUnits = "imperial"
    }
}
