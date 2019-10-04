//
//  WeatherModuleBuilder.swift
//  Weather Logger
//
//  Created by burak kaya on 03/10/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import UIKit

class WeatherModuleBuilder {
    static  func build() -> ViewController {
        let storyboard = UIStoryboard.init(name:"Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let router = WeatherRouter(view: view)
        let interactor = WeatherInteractor()
        let presenter = WeatherPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        return view
    }
}
