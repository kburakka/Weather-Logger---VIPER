//
//  DetailViewController.swift
//  Weather Logger
//
//  Created by burak kaya on 04/10/2019.
//  Copyright © 2019 burak kaya. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController, DetailViewProtocol {
    
    var presenter: DetailPresenterProtocol!
    
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.load()
    }
    
    func update(_ presentation: weatherInfo) {
        
        let mirror = Mirror(reflecting: presentation)
        
        var index = 0
        for child in mirror.children{
            index += 1
            let key = UILabel(frame: CGRect(x: 15, y: 100+(index*48), width: 115, height: 32))
            key.textAlignment = .left
            key.textColor = .white
            key.text = child.label
            key.lineBreakMode = .byWordWrapping
            key.numberOfLines = 2
            view.addSubview(key)
            
            
            let value = UILabel(frame: CGRect(x: 130, y: 100+(index*48), width: Int(view.frame.size.width) - 150, height: 32))
            value.textAlignment = .left
            value.textColor = .white
            value.text = " :   \(child.value)"
            value.lineBreakMode = .byWordWrapping
            value.numberOfLines = 2
            view.addSubview(value)
        }
    }
    
}
