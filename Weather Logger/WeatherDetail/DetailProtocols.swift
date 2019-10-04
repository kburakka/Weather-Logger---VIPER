//
//  DetailProtocols.swift
//  Weather Logger
//
//  Created by burak kaya on 04/10/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import UIKit

protocol DetailPresenterProtocol {
    func load()
}

protocol DetailViewProtocol: class {
    func update(_ presentation: weatherInfo)
}
