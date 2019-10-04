//
//  DetailBuilder.swift
//  Weather Logger
//
//  Created by burak kaya on 04/10/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import UIKit

final class DetailBuilder {
    static  func build(with weather: weatherInfo) -> DetailViewController {
        let storyboard = UIStoryboard.init(name:"Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let presenter = DetailPresenter(view: view, weather: weather)
        view.presenter = presenter
        return view
    }
}
