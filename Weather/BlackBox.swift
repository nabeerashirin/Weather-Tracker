//
//  BlackBox.swift
//  Weather
//
//  Created by Nabeera Shirin on 30/01/19.
//  Copyright © 2019 dummy. All rights reserved.
//

import Foundation
import UIKit


func showActivityIndicator(_ activityIndicator: UIActivityIndicatorView,_ controller: UIViewController,_ start: Bool){
    if start{
        controller.view.bringSubview(toFront: activityIndicator)
        activityIndicator.startAnimating()
    }
    else{
        activityIndicator.stopAnimating()
        controller.view.sendSubview(toBack: activityIndicator)
    }
}
