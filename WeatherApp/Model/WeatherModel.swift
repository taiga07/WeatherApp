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
    
    var tempString: String {
        return String(format: "%.1f", temp)
    }
    
}
