//
//  WeatherProtocols.swift
//  Weather Logger
//
//  Created by burak kaya on 03/10/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherPresenterProtocol : class{
    func viewDidLoad()
    func selectWeather(at index: Int)
    func getWeatherInfo(location : CLLocationCoordinate2D)
}

enum WeatherListPresenterOutput {
    case setLoading(Bool)
    case updateTitle(String)
    case showWeatherList([weatherInfo])
}



protocol WeatherInteractorProtocol : class{
    var delagete: WeatherInteractorDelegate? { get set }
    func viewDidLoad()
    func selectWeather(at index: Int)
    func getWeatherInfo(location : CLLocationCoordinate2D)
}

enum WeatherInteractorOutput {
    case setLoading(Bool)
    case showWeatherList([weatherInfo])
    case showWeatherDetail(weatherInfo)
}

protocol WeatherInteractorDelegate : class{
    func handleOutput(_ output:WeatherInteractorOutput)
}

protocol WeatherViewProtocol: class {
    func handleOutput(_ output :WeatherListPresenterOutput )
}

let apiKey = "00f368c25fc7658e428daf3bc4281b36"
struct weatherInfo {
    let name : String
    let country : String
    let temp : Float
    let date : String
    let windSpeed : Float
    let main : String
}
