//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{
    let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherManager.delegate = self
        searchTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
  @IBAction func locationButton(_ sender: UIButton) {
      locationManager.requestLocation()
      
  }
}
//MARK: - UITextFieldDelegate
extension  WeatherViewController:UITextFieldDelegate{
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityName = searchTextField.text{
            weatherManager.fetchWeather(cityName:cityName)}
        searchTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != ""{
            return true
        }else{
            searchTextField.placeholder = "Type something"
            return false
        }
    }
    
}
//MARK: - WeatherManagerDelagate
extension WeatherViewController:WeatherManagerDelagate{
    
    func didUpdateWeather(_ weatherManager:WeatherManager,weather:WeatherModel)  {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
        
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}
//MARK: - CLLocationManagerDelegate
extension WeatherViewController:CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
        let lat = location.coordinate.latitude
         let lon = location.coordinate.longitude
        
            weatherManager.fetchWeather(longitude: lon, latitude: lat)
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
      
    
}
