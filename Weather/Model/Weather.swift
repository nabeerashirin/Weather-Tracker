//
//  Weather.swift
//  Weather
//
//  Created by Nabeera K Shirin on 7/01/19.
//  Copyright © 2019 dummy. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Weather {
    var name: String?
    
    var humidity: Int?
    var wind: Double?
    var chance: Int?
    
    var temp: Double?
    var tempMin: Int?
    var tempMax: Int?
    
    var image: String?

    init(json: JSON) {
        self.name = json["name"].string
        self.humidity = json["main"]["humidity"].int
        self.temp = json["main"]["temp"].double
        self.tempMax = json["main"]["temp_max"].int
        self.tempMin = json["main"]["temp_min"].int
        self.wind = json["wind"]["speed"].double
        self.chance = json["clouds"]["all"].int
        self.image = json["weather"][0]["icon"].string
    }
}
