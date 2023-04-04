//
//  WeatherData.swift
//  WeatherForWeera
//
//  Created by Vazgen on 4/4/23.
//

import Foundation

struct WeatherResponse: Codable {
    let message: String
    let cod: String
    let count: Int
    let list: [WeatherData]
}

struct WeatherData: Codable {
    let id: Int
    let name: String
    let coord: Coordinates
    let main: MainInfo
    let dt: Int
    let wind: WindInfo
    let sys: SysInfo
    let rain: Precipitation?
    let snow: Precipitation?
    let clouds: CloudInfo
    let weather: [WeatherDescription]
}

struct Coordinates: Codable {
    let lat: Double
    let lon: Double
}

struct MainInfo: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int

    private enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
}

struct WindInfo: Codable {
    let speed: Double
    let deg: Int
}

struct SysInfo: Codable {
    let country: String
}

struct Precipitation: Codable {
    private enum CodingKeys: String, CodingKey {
        case lastHour = "1h"
    }

    let lastHour: Double
}

struct CloudInfo: Codable {
    let all: Int
}

struct WeatherDescription: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
