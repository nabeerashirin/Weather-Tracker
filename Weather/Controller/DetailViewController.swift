//
//  DetailViewController.swift
//  Weather
//
//  Created by Nabeera K Shirin on 5/01/19.
//  Copyright © 2019 dummy. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var weatherData: Weather? {
        didSet {
            if cloudImageView == nil {
                return
            }
            cloudImageView.image =  UIImage(named: WeatherManager.shared.getIcon(cloud: weatherData?.image )) ?? #imageLiteral(resourceName: "Clouds")
            tempLabel.text = "\(Int(weatherData?.temp! ?? 0 ))°C"
            windLabel.text = "Wind \n\(weatherData?.wind! ?? 0) m/s"
            rainLabel.text = "Rain chance \(weatherData?.chance! ?? 0)%"
            humidityLabel.text = "Humidity \(weatherData?.humidity! ?? 0)% "
            title = weatherData?.name
            barButtonStatus()
  
            
        }
    }
    //MARK: Outlets
    @IBOutlet weak var cloudImageView: UIImageView! {
        didSet {
            cloudImageView.image =  UIImage(named: WeatherManager.shared.getIcon(cloud: weatherData?.image) ) ?? #imageLiteral(resourceName: "Clouds")
        }
    }
    @IBOutlet weak var tempLabel: UILabel! {
        didSet {
            tempLabel.text = "\(Int(weatherData?.temp! ?? 0 ))°C"
        }
    }
    @IBOutlet weak var windLabel: UILabel! {
        didSet {
            windLabel.text = "Wind \n\(weatherData?.wind! ?? 0) m/s"
        }
    }
    @IBOutlet weak var rainLabel: UILabel! {
        didSet {
            rainLabel.text = "Rain chance \(weatherData?.chance! ?? 0)%"
        }
    }
    @IBOutlet weak var humidityLabel: UILabel! {
        didSet {
            humidityLabel.text = "Humidity \(weatherData?.humidity! ?? 0)% "
        }
    }
    @IBOutlet weak var statusBarButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.items![0].backBarButtonItem?.image = #imageLiteral(resourceName: "Back")
        navigationController?.navigationBar.items![0].title = ""
        title = weatherData?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if weatherData != nil {
            barButtonStatus()
            activityIndicator.stopAnimating()
        }
    }
    // MARK: Delete city
    
    @IBAction func DeleteCity(_ sender: UIBarButtonItem) {
        guard weatherData != nil else {
            return
        }
        
        if statusBarButton.image == #imageLiteral(resourceName: "del") {
            let alert = UIAlertController(title: "",
                                          message: "Do you want delete \((weatherData?.name)!) from you list?",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                CoreDataManager.shared.deleteByName(city: self.weatherData?.name)
                self.statusBarButton.image = #imageLiteral(resourceName: "Add")
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        if statusBarButton.image == #imageLiteral(resourceName: "Add") {
            if let weather = weatherData {
                CoreDataManager.shared.save(weather)
                popUP(text: "\(weather.name!) added to your list!")
                statusBarButton.image = #imageLiteral(resourceName: "del")
            }
        }
        
    }
    
    func barButtonStatus () {
        if CoreDataManager.shared.check(weatherData?.name) {
            statusBarButton.image = #imageLiteral(resourceName: "del")
        } else {
            statusBarButton.image = #imageLiteral(resourceName: "Add")
        }
    }
    
    //pop message
    public func popUP(text: String) {
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 1.0
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
