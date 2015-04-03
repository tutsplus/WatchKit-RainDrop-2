//
//  WeatherData.swift
//  RainDrop
//
//  Created by Bart Jacobs on 03/04/15.
//  Copyright (c) 2015 Tuts+. All rights reserved.
//

import Foundation

struct WeatherData {
    let date: NSDate
    let location: String
    let temperature: Double
    
    var fahrentheit: Double {
        return temperature * (9 / 5) + 32
    }
    
    func toCelciusString() -> String {
        return "\(temperature) °C"
    }
    
    func toFahrenheitString() -> String {
        return "\(fahrentheit) °F"
    }
}
