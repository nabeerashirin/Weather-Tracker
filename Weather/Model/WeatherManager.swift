//
//  CityManager.swift
//  Weather
//
//  Created by Nabeera K Shirin on 7/01/19.
//  Copyright © 2019 dummy. All rights reserved.
//

import Foundation
import OpenWeatherSwift
import SwiftyJSON
import CoreLocation

class WeatherManager {
    static let shared = WeatherManager()
    
    var cityArr = [Weather]()
    
    private var newApi = OpenWeatherSwift(apiKey: "df1b232f2cf2310fbe46e6ae43856c37",
                                          temperatureFormat: .Celsius)
    
    func addCity(name: String, handler: @escaping (Bool, Weather) -> Void) {
        if !checkCity(name) {
            handler(false, Weather(json: []))
            return
        }
        newApi.currentWeatherByCity(name: name) { jsonAnswer in
            if jsonAnswer["cod"] == "404" {
                handler(false, Weather(json: []))
                return
            }
            else if jsonAnswer["error"] == "error"{
                 handler(false, Weather(json: JSON(["error":"No location"])))
            }
            let weatherJson = Weather(json: jsonAnswer)
            self.cityArr.append(weatherJson)
            handler(true, weatherJson)
        }
    }
    
    
    func addCity(coords: CLLocationCoordinate2D, handlerCoord: @escaping (Bool, Weather) -> Void) {
        newApi.currentWeatherByCoordinates(coords: coords) { jsonAns  in
            if jsonAns["cod"] == "404" {
                handlerCoord(false, Weather(json: []))
                return
            }
            else if jsonAns["error"] == "error"{
                handlerCoord(false, Weather(json: JSON(["error":"No location"])))
            }
            else{
            let weatherJsonCoord = Weather(json: jsonAns)
            handlerCoord(true, weatherJsonCoord)
            }
        }
    }
    
    func checkCity(_ name: String?) -> Bool {
        return !cityArr.contains { $0.name == name }
    }
    
    func getIcon( cloud: String?) -> String {
        switch cloud {
        case  "01d", "01n":
            return "Clear"
        case "02d", "02n", "50d", "50n", "04d", "04n":
            return "Few"
            
        case "03d", "03n", "13d", "13n" :
            return "Clouds"
            
        case "09d", "09n", "10d", "10n":
            return "Rain"
            
        case "11d", "11n":
            return "Thunderstorm"
        default:
            return ""
        }
    }
    
}
