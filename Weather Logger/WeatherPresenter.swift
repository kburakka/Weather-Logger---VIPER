//
//  WeatherPresenter.swift
//  Weather Logger
//
//  Created by burak kaya on 03/10/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

final class WeatherPresenter :WeatherPresenterProtocol {
    private unowned let view: WeatherViewProtocol?
    private let interactor: WeatherInteractorProtocol
    private let router: WeatherRouterProtocol
    
    init(view:WeatherViewProtocol, interactor: WeatherInteractorProtocol, router: WeatherRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        
        self.interactor.delagete = self
    }
    
    func viewDidLoad() {
        view?.handleOutput(.updateTitle("Weather Logger"))
        interactor.viewDidLoad()
    }
    func selectWeather(at index: Int) {
        interactor.selectWeather(at: index)
    }
}

extension WeatherPresenter:WeatherInteractorDelegate{
    func handleOutput(_ output: WeatherInteractorOutput) {
        switch output {
        case .setLoading(let isLoading):
            view?.handleOutput(.setLoading(isLoading))
        case .showWeatherList(let weathers):
            view?.handleOutput(.showWeatherList(weathers))
        case .showWeatherDetail(let weather):
            router.navigate(to: .detail(weather))
        }
    }
}


