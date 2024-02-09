//
//  ViewController.swift
//  WeatherApp
//
//  Created by 谷太海 on 2024/02/06.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    var weatherManager = WeatherManager()
    //位置情報を取得するためのクラス
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        //アプリ立ち上げた際に、ユーザーに位置情報を提供するかどうかのポップアップを表示
        locationManager.requestWhenInUseAuthorization()
        //位置情報を一度だけ許可する場合は下記メソッド。アプリ使用中ずっと位置情報を取得する場合は、startUpdatingLocation()
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    //虫眼鏡押した時
    @IBAction func searchPressed(_ sender: UIButton) {
        //キーボードを閉じる
        searchTextField.endEditing(true)
    }
    
    //キーボードのreturn（go）押下時
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //キーボードを閉じる
        searchTextField.endEditing(true)
        
        return true
    }
    
    //ユーザーがテキストフィールドの編集を終えた時に実行
    //テキストフィールドの内容を確認するのに利用できるメソッド
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "入力してください"
            return false
        }
    }
    
    //画面上のテキストフィールドのどれかの編集が終わると実行される
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.createURL(city)
        }
        textField.text = ""
    }
}

//MARK: - WeatherManagerDelegate
extension ViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempString
            self.cityNameLabel.text = weather.name
            self.weatherImage.image = UIImage(systemName: weather.weatherIcon)
        }
    }
    
    func didFaillWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //位置情報は正確な場所を特定するために何度か更新されるから、最後の値をlastで取得する。
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            //経度
            let lat = location.coordinate.latitude
            //緯度
            let lon = location.coordinate.longitude
            weatherManager.createURL(lat, lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
