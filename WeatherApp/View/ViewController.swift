//
//  ViewController.swift
//  WeatherApp
//
//  Created by 谷太海 on 2024/02/06.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
    }
    
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
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempString
            self.cityNameLabel.text = weather.name
        }
    }
    
    func didFaillWithError(error: Error) {
        print(error)
    }
    
    
    @IBAction func locationPressed(_ sender: UIButton) {
    }
    

}

