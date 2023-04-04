//
//  Double+Extensions.swift
//  WeatherForWeera
//
//  Created by Vazgen on 4/4/23.
//

import Foundation


extension Double {
    public var celsiusValueFromKelvin: Int {
        return Int(self - 273.15)
    }
}
