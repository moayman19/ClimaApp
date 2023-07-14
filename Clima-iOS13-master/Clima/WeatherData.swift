//
//  weatherData.swift
//  Clima
//
//  Created by MohammedAyman on 5/5/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit

struct WeatherData:Codable{
    let name:String
    let main:Main
    let weather:[Weather]
    
}

struct Main:Codable {
    let temp:Double
}

struct Weather:Codable {
    let description:String
    let id:Int
}
