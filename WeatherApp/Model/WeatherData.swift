//
//  WeatherData.swift
//  WeatherApp
//
//  Created by 谷太海 on 2024/02/06.
//
//取得してきたJSONの中から、欲しい情報の名称を定義する。

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}

