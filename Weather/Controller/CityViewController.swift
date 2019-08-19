//
//  CityViewController.swift
//  Weather
//
//  Created by Nabeera K Shirin on 2/01/19.
//  Copyright © 2019 dummy. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {

    //MARK: properties
    
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var cityTableView: UITableView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    weak var cityDelegate: CityDelegate?
    var sortArr = CityList.shared.getSortedList()
    var filteredData = [[String]]()
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citySearchBar.delegate = self
        cityTableView.delegate = self
        cityTableView.dataSource = self
        cityTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cityCell")
        cityTableView.keyboardDismissMode = .onDrag
    }
    
}

extension CityViewController: UISearchBarDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        citySearchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text ?? "").isEmpty {
            inSearchMode = false
            cityTableView.reloadData()
        } else {
            inSearchMode = true
            filteredData = sortArr.map {
                $0.filter {
                    $0.lowercased().contains(searchBar.text!.lowercased())
                }
            }
            filteredData = filteredData.filter {$0.isEmpty  == false }
            cityTableView.reloadData()
        }
    }
}

//MARK: Table View

extension CityViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if inSearchMode {
            return filteredData.count
        }
        return sortArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredData[section].count
        }
        return sortArr[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if inSearchMode {
            return String(Array(filteredData[section][0])[0])
        }
        return String(Array(sortArr[section][0])[0])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        
            cell.textLabel?.text = inSearchMode ? filteredData[indexPath.section][indexPath.row] :
                                                  sortArr[indexPath.section][indexPath.row]
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let city =  inSearchMode ? filteredData[indexPath.section][indexPath.row] :
                                   sortArr[indexPath.section][indexPath.row]
        
        let controller = storyboard!.instantiateViewController(
            withIdentifier: "DetailViewController") as? DetailViewController
        
        if  !WeatherManager.shared.checkCity(city) {
            controller?.weatherData = WeatherManager.shared.cityArr.first {$0.name == city }
            navigationController!.pushViewController(controller!, animated: true)
        } else {
            showActivityIndicator(self.activityIndicator, self, true)
            WeatherManager.shared.addCity(name: city) { (success, weather)in
                if success{
                    
                    DispatchQueue.main.async {
                        self.cityDelegate?.updateCityList()
                        controller?.weatherData = WeatherManager.shared.cityArr.first {$0.name == city }
                        showActivityIndicator(self.activityIndicator, self, false)
                        self.navigationController!.pushViewController(controller!, animated: true)
                    }
                }
                else{
                    showActivityIndicator(self.activityIndicator, self, false)
                    let alert = UIAlertController(title: "Alert",message: "Unable to get the city's weather",preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss",style: .cancel, handler: nil))
                     self.present(alert, animated: true, completion: nil)
                    

                }
               
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
            cell.backgroundColor = UIColor(red: 41/255, green: 45/255, blue: 48/255, alpha: 1)
            cell.textLabel?.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
