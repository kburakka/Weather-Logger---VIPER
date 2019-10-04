//
//  WeatherInteractor.swift
//  Weather Logger
//
//  Created by burak kaya on 03/10/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//
import CoreData
import UIKit
import Foundation
import CoreLocation
import SwiftyJSON

var weatherInfos = [weatherInfo]()

final class WeatherInteractor: WeatherInteractorProtocol {

    weak var delagete: WeatherInteractorDelegate?

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    func viewDidLoad() {
        delagete?.handleOutput(.setLoading(true))
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather")
        request.returnsObjectsAsFaults = false
        do {
            delagete?.handleOutput(.setLoading(false))
            weatherInfos.removeAll()
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let name = data.value(forKey: "name") as! String
                let country = data.value(forKey: "country") as! String
                let temp = data.value(forKey: "temp") as! Float
                let date = data.value(forKey: "date") as! String
                let main = data.value(forKey: "main") as! String
                let windSpeed = data.value(forKey: "windSpeed") as! Float
                weatherInfos.append(weatherInfo(name: name, country: country, temp: temp, date: date, windSpeed: windSpeed, main: main))
            }
            self.delagete?.handleOutput(.showWeatherList(weatherInfos))

        } catch {
            print("Failed")
        }
    }
    
    func selectWeather(at index: Int) {
        let weather = weatherInfos[index]
        delagete?.handleOutput(.showWeatherDetail(weather))
    }
    
    func getWeatherInfo(location: CLLocationCoordinate2D){
        delagete?.handleOutput(.getWeatherInfo(location))
    }
    
    func saveToDataBase(weatherJson: JSON) {
        delagete?.handleOutput(.saveToDataBase(weatherJson))
    }
    
    func loadToArray() {
        delagete?.handleOutput(.loadToArray)
    }
}
