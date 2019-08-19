//
//  CoreDataManager.swift
//  Weather
//
//  Created by Nabeera K Shirin on 5/01/19.
//  Copyright © 2019 dummy. All rights reserved.
//
import Foundation
import CoreData
import SwiftyJSON

class CoreDataManager {
    static let shared = CoreDataManager()
    
    func save(_ cityToSave: Weather) {
        
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CityManaged", in: context)
        let newCity = NSManagedObject(entity: entity!, insertInto: context)
       
        newCity.setValue(cityToSave.name, forKey: "name")
        newCity.setValue(cityToSave.humidity, forKey: "humidity")
        newCity.setValue(cityToSave.wind, forKey: "wind")
        newCity.setValue(cityToSave.chance, forKey: "chance")
        newCity.setValue(cityToSave.temp, forKey: "temp")
        newCity.setValue(cityToSave.tempMin, forKey: "tempMin")
        newCity.setValue(cityToSave.tempMax, forKey: "tempMax")
        newCity.setValue(cityToSave.image, forKey: "image")

        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetch( handle: @escaping (_ result: [NSManagedObject], _ cities: [Weather]) -> Void) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CityManaged")
        request.returnsObjectsAsFaults = false
        do {
            if let results = try context.fetch(request) as? [NSManagedObject] {
                var weather = [Weather]()
                for result in results {
                    weather.append(Weather(json:
                        JSON(["name": result.value(forKey: "name"),
                              "main": ["humidity": result.value(forKey: "humidity"),
                                        "temp": result.value(forKey: "temp"),
                                        "temp_max": result.value(forKey: "tempMax"),
                                        "temp_min": result.value(forKey: "tempMin")],
                              "wind": ["speed": result.value(forKey: "wind")],
                              "clouds": ["all": result.value(forKey: "chance")],
                              "weather": [["icon": result.value(forKey: "image")]]])))
                }
                handle(results, weather)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func check(_ city: String?) -> Bool {
        var answer = Bool()
        fetch { _, weather in
            for weath in weather where weath.name! == city {
                answer =  true
            }
        }
        return answer
    }
    
    func deleteByName(city: String?) {
        fetch { manage, _  in
            let context = CoreDataStack.shared.persistentContainer.viewContext
            if manage.isEmpty {
                return
            }
            for obj in 0...manage.count - 1 where manage[obj].value(forKey: "name") as? String == city {
                context.delete(manage[obj])
            }
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
}
