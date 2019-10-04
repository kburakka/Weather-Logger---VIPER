//
//  WeatherProtocols.swift
//  Weather Logger
//
//  Created by burak kaya on 03/10/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON


//Presenter
protocol WeatherPresenterProtocol : class{
    func viewDidLoad()
    func selectWeather(at index: Int)
    func getWeatherInfo(location : CLLocationCoordinate2D, completionHandler: @escaping  (JSON) -> ())
    func saveToDataBase(weatherJson : JSON, completionHandler: @escaping  () -> ())
    func loadToArray(completionHandler: @escaping  () -> ())
}

enum WeatherListPresenterOutput {
    case setLoading(Bool)
    case updateTitle(String)
    case showWeatherList([weatherInfo])
}


//Router
protocol WeatherRouterProtocol: class {
    func navigate(to route:WeatherRoute)
}

enum WeatherRoute{
    case detail(weatherInfo)
}


// Interector
protocol WeatherInteractorProtocol : class{
    var delagete: WeatherInteractorDelegate? { get set }
    func viewDidLoad()
    func selectWeather(at index: Int)
}

enum WeatherInteractorOutput {
    case setLoading(Bool)
    case showWeatherList([weatherInfo])
    case showWeatherDetail(weatherInfo)
}

protocol WeatherInteractorDelegate : class{
    func handleOutput(_ output:WeatherInteractorOutput)
}


// View
protocol WeatherViewProtocol: class {
    func handleOutput(_ output :WeatherListPresenterOutput )
}


// Environment
let apiKey = "00f368c25fc7658e428daf3bc4281b36"
var weatherInfos = [weatherInfo]()

struct weatherInfo {
    let name : String
    let country : String
    let temp : Float
    let date : String
    let windSpeed : Float
    let main : String
    
    init(name:String, country:String, temp:Float, date:String, windSpeed:Float, main:String)
    {

        self.name = name
        self.country = country
        self.temp = temp
        self.date = date
        self.windSpeed = windSpeed
        self.main = main
     }
}
