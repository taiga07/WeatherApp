//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by 谷太海 on 2024/02/06.
//

import Foundation

protocol WeatherManagerDelegate {
    //Viewでdataの値を使用できるように関数を宣言
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    //エラー内容はこっちに
    func didFaillWithError(error: Error)
}

struct WeatherManager {
    
    //確定しているURL。ここにユーザーが入力した都市名を付ける
    /*
     Httpの場合、安全ではない方法でアクセスするため。Appleがそれを検出してエラーを出す。
     Httpsとすることで、回避する。
     */
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&units=metric"
    //自身のAPIkey
    let apiKey = Constants.apiKey
    
    var delegate: WeatherManagerDelegate?
    
    //ユーザーが入力した都市名を受け取りURLの作成
    func createURL(_ cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)&appid=\(apiKey)"
        //作成したURLを渡してリクエストを投げる
        performRequest(urlString)
    }
    
    /*
     リクエストを投げて天気予報を取得する。
     ステップ1：URLを作成
     ステップ2：URLセッションの作成
     ステップ3：セッションにタスクを持たせる
     ステップ4：タスクの実行
     */
    func performRequest(_ urlString: String){
        //ステップ1
        if let url = URL(string: urlString){
            
            //ステップ2
            let session = URLSession(configuration: .default)
            
            //ステップ3
            //タスクが実行された後、in 以降の処理が実行される。handleメソッドをinの中で実装できる。
            let task = session.dataTask(with: url) { data, responce, error in
                //タスクの実行結果でerrorが発生しているかチェック
                if error != nil{
                    delegate?.didFaillWithError(error: error!)
                    return
                }
                //eerrorでない場合、取得したdataをperseJSONメソッドに渡し、Swift形式に変換する。
                if let safeData = data {
                    if let weather = self.perseJSON(safeData){
                        //weatherの情報をViewに返したいが、特定のViewへの接続をベタ書きするのはナンセンスなので、delegateを利用。
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //ステップ4
            task.resume()
        }
    }
    
    //responceデータをSwift形式で扱えるようにする
    func perseJSON(_ safeData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: safeData)
            let cityName = decodedData.name
            let temp = decodedData.main.temp
            let weather = WeatherModel(name: cityName, temp: temp)
            return weather
        } catch {
            delegate?.didFaillWithError(error: error)
            return nil
        }
        
    }
}
