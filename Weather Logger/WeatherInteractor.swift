//
//  WeatherInteractor.swift
//  Weather Logger
//
//  Created by burak kaya on 03/10/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import CoreLocation
import CoreData

public class getData{
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
      public func getWeatherInfo(locValue:CLLocationCoordinate2D, view : UIView){
        let currenLocationApi = "http://api.openweathermap.org/data/2.5/weather?lat=\(locValue.latitude)&lon=\(locValue.longitude)&APPID=\(apiKey)"

        let url = URL(string: currenLocationApi)!
        showActivityIndicator(selectedView: view)
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            let weatherJson : JSON = JSON(data)
            print(weatherJson)
            self.saveData(weatherJson: weatherJson)
            DispatchQueue.main.async {
                self.stopActivityIndicator()
            }
        }
        task.resume()
    }
    func showActivityIndicator(selectedView: UIView){
        container.frame = CGRect(x: 0, y: 0, width: selectedView.frame.size.width, height: selectedView.frame.size.height)
        container.backgroundColor = UIColorFromRGB(rgbValue: 0xffffff).withAlphaComponent(CGFloat(0.3))
        
        loadingView.frame.size.width = 80
        loadingView.frame.size.height = 80
        loadingView.center = selectedView.center
        loadingView.backgroundColor = UIColorFromRGB(rgbValue: 0x444444).withAlphaComponent(CGFloat(0.7))
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame.size.width = 40
        activityIndicator.frame.size.height = 40
        activityIndicator.style = .whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        activityIndicator.startAnimating()
        selectedView.addSubview(container)
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopActivityIndicator(){
        UIApplication.shared.endIgnoringInteractionEvents()
        container.removeFromSuperview()
        loadingView.removeFromSuperview()
        activityIndicator.stopAnimating()
    }
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    func saveData(weatherJson:JSON ,completion: (() -> Void)? = nil) {
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
            completion?()
//            getData()
        } catch {
            print("Failed saving")
        }
    }
}
