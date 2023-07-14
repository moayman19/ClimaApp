//
//  weatherManager.swift
//  Clima
//
//  Created by MohammedAyman on 5/4/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
protocol  WeatherManagerDelagate{
    func didUpdateWeather(_ weatherManager:WeatherManager,weather:WeatherModel)
    func didFailWithError(error:Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelagate?
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?&appid=86639a3701e0b4037e5cb3404d042d07&units=metric"
    
    
    func fetchWeather(cityName:String){
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeather(longitude:CLLocationDegrees,latitude:CLLocationDegrees) {
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
               performRequest(with: urlString)
    }

    
    func performRequest(with urlString:String) {
        // create a url
        if let url = URL(string: urlString){
            // create a url session
            let session = URLSession(configuration:.default)
            //give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    // return because to exit func
                    return
                }
                if let safeData = data{
                    if let weather = self.parseJSON(with: safeData){
                        
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                 
                }
            }
            //start the task
            task.resume()
        }
    }
    
    func  parseJSON(with weatherdata:Data) ->WeatherModel? {
        let decoder = JSONDecoder()
        do {
          let decodeedData = try decoder.decode(WeatherData.self, from: weatherdata)
            let id = decodeedData.weather[0].id
            let temp = decodeedData.main.temp
            let name = decodeedData.name
            let weather = WeatherModel(id: id, cityName: name, temperature: temp)
            return weather
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}



