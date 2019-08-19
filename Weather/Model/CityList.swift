//
//  CityList.swift
//  Weather
//
//  Created by Nabeera K Shirin on 7/01/19.
//  Copyright © 2019 dummy. All rights reserved.
//

import Foundation
import SwiftyJSON

class CityList {
    
    static let shared = CityList()
    private var citiesList: [String]?
    
    func getCities() -> [String] {
        var cities = [String]()
        let url = Bundle.main.url(forResource: "cities_with_countries", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        let json = JSON(data as Any)
        for jsonCount in 0..<json.count {
            cities.append(json[jsonCount]["city"].string!)
        }
        cities.sort()
        self.citiesList  = cities
        return cities
    }
    
    func getSortedList() -> [[String]] {
        var tmparr = [String]()
        for each in getCities() {
            tmparr.append(String(Array(each)[0]))
        }
        let letters = Array(Set(tmparr)).sorted()

        var sortderArr = Array(repeating: [String](), count: letters.count)

        for jsonCount in 0..<letters.count {
            for city in citiesList! {
                if String(Array(city)[0]) == letters[jsonCount] {
                    sortderArr[jsonCount].append(city)
                }
            }
        }        
        return sortderArr
    }
    
}
