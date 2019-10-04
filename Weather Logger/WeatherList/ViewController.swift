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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @objc func toMap(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard.init(name:"Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        view.modalPresentationStyle = .fullScreen
        let router = WeatherRouter(view: view)
        let interactor = WeatherInteractor()
        let presenter = WeatherPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        
        presenter.getWeatherInfo(location: locValue)  { (array) in
            self.presenter.saveToDataBase(weatherJson: array) {
                self.presenter.loadToArray(){
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func handleOutput(_ output: WeatherListPresenterOutput) {
        switch output {
        case .updateTitle(let title):
            self.title = title
        case .setLoading(let isLoading):
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
        case .showWeatherList(let movies):
            weatherInfos = movies
            tableView.reloadData()
        case .getWeatherInfo(let location):
            print(location)
        case .saveToDataBase(let json):
            print(json)
        case .loadToArray:
            tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        cell.selectionStyle = .none
        cell.temp.text = "Temperature :  \(weatherInfos[indexPath.row].temp)°"
        cell.date.text = weatherInfos[indexPath.row].date
        return cell
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        presenter.selectWeather(at: indexPath.row)
        print(weatherInfos[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let fetchRequest: NSFetchRequest<Weather> = Weather.fetchRequest()
            do{
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let tasks = try context.fetch(fetchRequest)
                context.delete(tasks[indexPath.row])
                try context.save()
            }catch{
                print(error)
            }
            weatherInfos.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
