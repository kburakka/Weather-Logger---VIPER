//
//  ViewController.swift
//  Weather Logger
//
//  Created by burak kaya on 02/10/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import CoreData


final class ViewController: UIViewController,WeatherViewProtocol,CLLocationManagerDelegate{
    @IBOutlet weak var tableView: UITableView!

    let locationManager : CLLocationManager = CLLocationManager()
    private var weatherInfos : [weatherInfo] = []
    var presenter: WeatherPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Map >", style: .done, target: self, action: #selector(self.toMap(sender:)))
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        //        getData()
    }
    
    @objc func toMap(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard.init(name:"Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        view.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(view, animated: true)
    }
    
        @IBAction func save(_ sender: Any) {
    //        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
    //        getWeatherInfo(locValue: locValue, view: self.view)
        }
    func handleOutput(_ output: WeatherListPresenterOutput) {
        switch output {
        case .updateTitle(let title):
            self.title = title
           
        case .setLoading(let isLoading):
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
        case .showWeatherList(let movies):
            self.weatherInfos = movies
            tableView.reloadData()
        }
    }
    
//    let locationManager = CLLocationManager()

//    let date = Date.init(timeIntervalSinceReferenceDate: 86400)

    

    
//    private var weatherInfos : [weatherInfo] = []

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 92
    }

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return weatherInfos.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
//        cell.selectionStyle = .none
//        print("\(weatherInfos[indexPath.row].temp)")
//        cell.temp.text = "Temperature :  \(weatherInfos[indexPath.row].temp)°"
//        cell.date.text = weatherInfos[indexPath.row].date
//        return cell
//    }
//    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        print(weatherInfos[indexPath.row])
//    }
//    
//    func kelvinToC(kelvin:Float)->Float{
//        return kelvin - 272.15
//    }

//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    func getData(){
//        let context = appDelegate.persistentContainer.viewContext
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather")
//        request.returnsObjectsAsFaults = false
//        do {
//            weatherInfos.removeAll()
//            let result = try context.fetch(request)
//            for data in result as! [NSManagedObject] {
//                let name = data.value(forKey: "name") as! String
//                let country = data.value(forKey: "country") as! String
//                let temp = data.value(forKey: "temp") as! Float
//                let date = data.value(forKey: "date") as! String
//                let main = data.value(forKey: "main") as! String
//                let windSpeed = data.value(forKey: "windSpeed") as! Float
//                weatherInfos.append(weatherInfo(name: name, country: country, temp: temp, date: date, windSpeed: windSpeed, main: main))
//            }
//        } catch {
//            print("Failed")
//        }
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//    }
//
//    func saveData(weatherJson:JSON ){
//        var degree = Float()
//
//        if let temp = weatherJson["main"]["temp"].float{
//            degree = kelvinToC(kelvin: temp)
//            degree = Float(round(10*degree)/10)
//        }
//
//        let context = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "Weather", in: context)
//        let newWeatherData = NSManagedObject(entity: entity!, insertInto: context)
//        newWeatherData.setValue(weatherJson["sys"]["country"].string, forKey: "country")
//        newWeatherData.setValue(weatherJson["name"].string, forKey: "name")
//        newWeatherData.setValue(degree, forKey: "temp")
//        newWeatherData.setValue(getCurrentDateTime(), forKey: "date")
//        newWeatherData.setValue(weatherJson["weather"][0]["main"].string, forKey: "main")
//        newWeatherData.setValue(weatherJson["wind"]["speed"].float, forKey: "windSpeed")
//
//        do {
//            try context.save()
//            getData()
//        } catch {
//            print("Failed saving")
//        }
//    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == .delete) {
//            let fetchRequest: NSFetchRequest<Weather> = Weather.fetchRequest()
//            do{
//                let context = appDelegate.persistentContainer.viewContext
//                let tasks = try context.fetch(fetchRequest)
//                context.delete(tasks[indexPath.row])
//                try context.save()
//            }catch{
//                print(error)
//            }
//            weatherInfos.remove(at: indexPath.row)
//            tableView.reloadData()
//        }
//    }
    
//    func getCurrentDateTime() -> String{
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.timeStyle = .short
//        formatter.dateStyle = .medium
//        let currentDate = formatter.string(from: date)
//
//        return currentDate
//    }

//     func getWeatherInfo(locValue:CLLocationCoordinate2D, view : UIView){
//        let currenLocationApi = "http://api.openweathermap.org/data/2.5/weather?lat=\(locValue.latitude)&lon=\(locValue.longitude)&APPID=\(apiKey)"
//
//        let url = URL(string: currenLocationApi)!
//        showActivityIndicator(selectedView: view)
//        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//            guard let data = data else { return }
//            let weatherJson : JSON = JSON(data)
//            print(weatherJson)
//            self.saveData(weatherJson: weatherJson)
//            DispatchQueue.main.async {
//                self.stopActivityIndicator()
//            }
//        }
//        task.resume()
//    }
    
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    func showActivityIndicator(selectedView: UIView){
        container.frame = CGRect(x: 0, y: 0, width: selectedView.frame.size.width, height: selectedView.frame.size.height)
        container.backgroundColor = UIColorFromRGB(rgbValue: 0xffffff).withAlphaComponent(CGFloat(0.3))
        
        loadingView.frame.size.width = 80
        loadingView.frame.size.height = 80
        loadingView.center = view.center
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
}

//extension ViewController : WeatherView{
//    func updateTitle(title: String) {
//        print(title)
//    }
//}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        cell.selectionStyle = .none
        print("\(weatherInfos[indexPath.row].temp)")
        cell.temp.text = "Temperature :  \(weatherInfos[indexPath.row].temp)°"
        cell.date.text = weatherInfos[indexPath.row].date
        return cell
    }
    
}
