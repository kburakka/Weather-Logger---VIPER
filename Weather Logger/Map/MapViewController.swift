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

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate,WeatherViewProtocol {
    
    var presenter: WeatherPresenterProtocol!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTitle: UILabel!
    
    
    struct weatherMap {
        let type : String
        let alias : String
    }
    
    var currentIndex = 0
    
    let pressure = weatherMap(type: "pressure_new", alias: "Pressure")
    let wind = weatherMap(type: "wind_new", alias: "Wind Speed")
    let temp = weatherMap(type: "temp_new", alias: "Temperature")
    let precipitation = weatherMap(type: "precipitation_new", alias: "Precipitation")
    var weatherMaps = [weatherMap]()
    var gestureRecognizer : UITapGestureRecognizer = UITapGestureRecognizer()
    
    
    func handleOutput(_ output: WeatherListPresenterOutput) {
        switch output {
        case .updateTitle(let title):
            self.title = title
        case .setLoading(let isLoading):
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
        case .showWeatherList(let movies):
            weatherInfos = movies
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherMaps = [pressure,wind,temp,precipitation]
        
        setupTile(weatherMap: pressure)
        
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func showAlert(coordinate : CLLocationCoordinate2D){
        let alert = UIAlertController(title: "Weather Save", message: "Do you want to save weather info of this location?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action: UIAlertAction!) in
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self.mapView.addAnnotation(annotation)
            
            self.presenter.getWeatherInfo(location: coordinate)  { (array) in
                self.presenter.saveToDataBase(weatherJson: array) {
                    self.presenter.loadToArray(){
                    }
                }
            }
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
