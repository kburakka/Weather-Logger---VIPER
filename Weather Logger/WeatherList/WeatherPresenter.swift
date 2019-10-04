//
//  WeatherPresenter.swift
//  Weather Logger
//
//  Created by burak kaya on 03/10/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//
import CoreLocation
import SwiftyJSON
import CoreData

final class WeatherPresenter :WeatherPresenterProtocol {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private unowned let view: WeatherViewProtocol?
    private let interactor: WeatherInteractorProtocol
    private let router: WeatherRouterProtocol
    
    init(view:WeatherViewProtocol, interactor: WeatherInteractorProtocol, router: WeatherRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        
        self.interactor.delagete = self
    }
    
    func viewDidLoad() {
        view?.handleOutput(.updateTitle("Weather Logger"))
        interactor.viewDidLoad()
    }
    func selectWeather(at index: Int) {
        interactor.selectWeather(at: index)
    }
    
    func getWeatherInfo(location: CLLocationCoordinate2D, completionHandler: @escaping  (_ json:JSON) -> ()) {

        let currenLocationApi = "http://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&APPID=\(apiKey)"
        
        let url = URL(string: currenLocationApi)!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            let weatherJson : JSON = JSON(data)
            completionHandler(weatherJson)
        }
        task.resume()
    }
    
    func kelvinToC(kelvin:Float)->Float{
        return kelvin - 272.15
    }
    
    func getCurrentDateTime() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        let currentDate = formatter.string(from: date)
        
        return currentDate
    }
    
    func saveToDataBase(weatherJson: JSON, completionHandler: @escaping () -> ()) {
        var degree = Float()
        
        if let temp = weatherJson["main"]["temp"].float{
            degree = kelvinToC(kelvin: temp)
            degree = Float(round(10*degree)/10)
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Weather", in: context)
        let newWeatherData = NSManagedObject(entity: entity!, insertInto: context)
        newWeatherData.setValue(weatherJson["sys"]["country"].string, forKey: "country")
        newWeatherData.setValue(weatherJson["name"].string, forKey: "name")
        newWeatherData.setValue(degree, forKey: "temp")
        newWeatherData.setValue(getCurrentDateTime(), forKey: "date")
        newWeatherData.setValue(weatherJson["weather"][0]["main"].string, forKey: "main")
        newWeatherData.setValue(weatherJson["wind"]["speed"].float, forKey: "windSpeed")
        
        do {
            try context.save()
            
            completionHandler()
        } catch {
            print("Failed saving")
        }
    }
    
    func loadToArray( completionHandler: @escaping () -> ()) {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather")
        request.returnsObjectsAsFaults = false
        do {
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
            completionHandler()
        } catch {
            print("Failed")
        }
     }
}

extension WeatherPresenter:WeatherInteractorDelegate{
    func handleOutput(_ output: WeatherInteractorOutput) {
        switch output {
        case .setLoading(let isLoading):
            view?.handleOutput(.setLoading(isLoading))
        case .showWeatherList(let weathers):
            view?.handleOutput(.showWeatherList(weathers))
        case .showWeatherDetail(let weather):
            router.navigate(to: .detail(weather))
        }
    }
}


