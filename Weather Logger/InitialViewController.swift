//
//  InitialViewController.swift
//  Weather Logger
//
//  Created by burak kaya on 03/10/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let initialViewController = WeatherModuleBuilder.build()
        initialViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.setViewControllers([initialViewController], animated: true)
    }
}
