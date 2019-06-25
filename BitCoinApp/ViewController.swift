//
//  ViewController.swift
//  BitCoinApp
//
//  Created by pc on 6/24/19.
//  Copyright © 2019 pc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController  , UIPickerViewDelegate , UIPickerViewDataSource {
    //TODO: Global Constants and Variable:
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbol =  ["$", "R$", "$", "Â¥", "â‚¬", "Â£", "$", "Rp", "â‚ª", "â‚¹", "Â¥", "$", "kr", "$", "zÅ‚", "lei", "â‚½", "kr", "$", "$", "R"]
    
   
    var finalURL = ""
    var currencySelected : String = ""

    
    //Pre-setup IBOutlets:
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    //TODO: Place your 4 UIPickerView delegate methods here :
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        finalURL   = baseURL + (currencyArray[0])
        currencySelected = currencySymbol[0]
        getBitcoindata(url: finalURL)
        return currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        finalURL = baseURL + currencyArray[row]
        currencySelected = currencySymbol[row]
        getBitcoindata(url: finalURL)
    }
    
    //MARK: Networking
    //****************************************************
    func getBitcoindata(url:String){
        Alamofire.request(url , method : .get).responseJSON { (response) in
            if response.result.isSuccess {
                print("success")
                  let bitcoinJSON : JSON = JSON(response.result.value!)
                self.updateBitcoinData(json: bitcoinJSON)
            }
            else {
                print(response.result.error!)
            }
        }
    }
    // MARK: - JSON Parsing
    //*******************************************************
    func updateBitcoinData(json:JSON){
        if let resultBitcoin = json["ask"].double {
        bitcoinPriceLabel.text = "\(currencySelected)\(resultBitcoin)"
        }
        else {
            bitcoinPriceLabel.text = "Price Unavaiable"
        }
    }
}

