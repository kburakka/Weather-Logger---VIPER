//
//  WeatherRouter.swift
//  Weather Logger
//
//  Created by burak kaya on 03/10/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import UIKit

protocol WeatherRouterProtocol: class {
    func navigate(to route:WeatherRoute)
}


enum WeatherRoute{
    case detail(weatherInfo)
}

final class WeatherRouter: WeatherRouterProtocol {
    unowned let viewController: UIViewController
    init(view: UIViewController) {
        self.viewController = view
    }
    
    func navigate(to route: WeatherRoute) {
//        switch route {
//        case .detail(let weather):
//            let detailView = we
//        default:
//            <#code#>
//        }
    }
}
