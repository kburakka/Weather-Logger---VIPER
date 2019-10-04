//
//  WeatherRouter.swift
//  Weather Logger
//
//  Created by burak kaya on 03/10/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import UIKit

final class WeatherRouter: WeatherRouterProtocol {
    unowned let view: UIViewController
    init(view: UIViewController) {
        self.view = view
    }
    
    func navigate(to route: WeatherRoute) {
        switch route {
        case .detail(let weather):
            let detailView = DetailBuilder.build(with : weather)
            view.show(detailView, sender: nil)
        }
    }
}
