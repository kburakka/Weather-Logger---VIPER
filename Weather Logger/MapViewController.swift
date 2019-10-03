//
//  MapViewController.swift
//  Weather Logger
//
//  Created by burak kaya on 03/10/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation
import SwiftyJSON

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTitle: UILabel!
    var currentIndex = 0
    struct weatherMap {
        let type : String
        let alias : String
    }
    
    let pressure = weatherMap(type: "pressure_new", alias: "Pressure")
    let wind = weatherMap(type: "wind_new", alias: "Wind Speed")
    let temp = weatherMap(type: "temp_new", alias: "Temperature")
    let precipitation = weatherMap(type: "precipitation_new", alias: "Precipitation")

    var weatherMaps = [weatherMap]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var gestureRecognizer : UITapGestureRecognizer = UITapGestureRecognizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        weatherMaps = [pressure,wind,temp,precipitation]
        
        setupTile(weatherMap: pressure)
        
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

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
    
    
     func getWeatherInfo(locValue:CLLocationCoordinate2D, view : UIView){
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

    func kelvinToC(kelvin:Float)->Float{
        return kelvin - 272.15
    }
    
    func saveData(weatherJson:JSON ){
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
        newWeatherData.setValue("aa", forKey: "date")
        newWeatherData.setValue(weatherJson["weather"][0]["main"].string, forKey: "main")
        newWeatherData.setValue(weatherJson["wind"]["speed"].float, forKey: "windSpeed")

        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }

    func showAlert(coordinate : CLLocationCoordinate2D){
        let alert = UIAlertController(title: "Weather Save", message: "Do you want to save weather info of this location?", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action: UIAlertAction!) in
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self.mapView.addAnnotation(annotation)
            
            self.getWeatherInfo(locValue: coordinate, view: self.view)
    
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))

        present(alert, animated: true, completion: nil)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer){
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        showAlert(coordinate: coordinate)
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let tileOverlay = overlay as? MKTileOverlay else {
            return MKOverlayRenderer(overlay: overlay)
        }
        return MKTileOverlayRenderer(tileOverlay: tileOverlay)
    }
    
    @IBAction func mapStyle(_ sender: Any) {
        currentIndex = Int(Double(currentIndex + 1).truncatingRemainder(dividingBy: 4))
        setupTile(weatherMap: weatherMaps[currentIndex])
        
    }
    func setupTile(weatherMap : weatherMap) {
        
        if let last = mapView.overlays.last{
            mapView.removeOverlay(last)
        }
        
        let template = "https://tile.openweathermap.org/map/\(weatherMap.type)/{z}/{x}/{y}.png?appid=\(apiKey)"
        
        let overlay = MKTileOverlay(urlTemplate: template)

        mapView.addOverlay(overlay)
        self.mapTitle.text = weatherMap.alias
    }
}
