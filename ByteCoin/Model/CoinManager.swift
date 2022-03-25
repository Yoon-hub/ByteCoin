//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinMageDelegate{
    func UpdateUI(lastData: Double, type: String)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "03DED891-9874-4FBE-AD61-713E43DA807B"
    
    var delegate : CoinMageDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    
    func getCoinPrice(for currency: String){
        let usrString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
            
        if let url = URL(string: usrString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    print(error!)
                    return // 에러가 발생하면 다른일 안하겠다
                }
                if let safeData = data {
                    let lastData = self.parseJSON(safeData)
                    print(lastData)
                    delegate?.UpdateUI(lastData: lastData, type: currency)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastData = decodedData.rate
            return lastData

        }catch{
            return 0.0
        }
        
    }
}
