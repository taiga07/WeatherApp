//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by 谷太海 on 2024/02/06.
//
//このクラスに定義してある項目をViewなどで利用することができる。

import Foundation

struct WeatherModel {
    
    let name: String
    let temp: Double
    let weatherID: Int
    
    var tempString: String {
        return String(format: "%.1f", temp)
    }
    
    var weatherIcon: String {
        switch weatherID {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "sun.max"
        }
    }
    
    var weatherBackground: String {
        switch weatherID {
        case 200...232:
            return "rain"
        case 300...321:
            return "fog"
        case 500...531:
            return "rain"
        case 600...622:
            return "snow"
        case 701...781:
            return "cloudy"
        case 800:
            return "DefaultBackground"
        case 801...804:
            return "cloudy"
        default:
            return "DefaultBackground"
        }
    }
    
}
