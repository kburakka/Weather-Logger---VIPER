//
//  DetailPresenter.swift
//  Weather Logger
//
//  Created by burak kaya on 04/10/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import Foundation

final class DetailPresenter: DetailPresenterProtocol {
    
    unowned var view: DetailViewProtocol
    private let weather: weatherInfo
    
    init(view: DetailViewProtocol, weather: weatherInfo) {
        self.view = view
        self.weather = weather
    }
    
    func load() {
        view.update(weatherInfo(name: weather.name, country: weather.country, temp: weather.temp, date: weather.date, windSpeed: weather.windSpeed, main: weather.main))
    }
}
