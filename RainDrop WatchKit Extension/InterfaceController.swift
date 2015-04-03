//
//  InterfaceController.swift
//  RainDrop WatchKit Extension
//
//  Created by Bart Jacobs on 24/03/15.
//  Copyright (c) 2015 Tuts+. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    var weatherData: [WeatherData] = []
    
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    @IBOutlet weak var locationLabel: WKInterfaceLabel!
    @IBOutlet weak var temperatureLabel: WKInterfaceLabel!
    
    var weather: WeatherData? {
        return weatherData.first
    }
    
    var celcius: Bool = true {
        didSet {
            if celcius != oldValue {
                updateTemperatureLabel()
            }
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Load Weather Data
        loadWeatherData()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if let weather = self.weather {
            locationLabel.setText(weather.location)
            
            // Update Temperature Label
            self.updateTemperatureLabel()
            
            // Update Date Label
            self.updateDateLabel()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func loadWeatherData() {
        let path = NSBundle.mainBundle().pathForResource("weather", ofType: "json")
        
        if let path = path {
            let data = NSData(contentsOfFile: path)
            
            if let data = data {
                let weatherData = JSON(data: data)
                let locations = weatherData["locations"].array
                
                if let locations = locations {
                    for location in locations {
                        let timestamp = location["timestamp"].double!
                        let date = NSDate(timeIntervalSinceReferenceDate: timestamp)
                        
                        let model = WeatherData(date: date, location: location["location"].string!, temperature: location["temperature"].double!)
                        
                        self.weatherData.append(model)
                    }
                }
            }
        }
    }
    
    func updateTemperatureLabel() {
        if let weather = self.weather {
            if self.celcius {
                temperatureLabel.setText(weather.toCelciusString())
            } else {
                temperatureLabel.setText(weather.toFahrenheitString())
            }
        }
    }
    
    func updateDateLabel() {
        var date: NSDate = NSDate()
        
        // Initialize Date Formatter
        let dateFormattter = NSDateFormatter()
        
        // Configure Date Formatter
        dateFormattter.dateFormat = "d/MM HH:mm"
        
        if let weather = self.weather {
            date = weather.date
        }
        
        // Update Date Label
        dateLabel.setText(dateFormattter.stringFromDate(date))
    }
    
    @IBAction func toCelcius() {
        if !self.celcius {
            self.celcius = true
        }
    }
    
    @IBAction func toFahrenheit() {
        if self.celcius {
            self.celcius = false
        }
    }
}
