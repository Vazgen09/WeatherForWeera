//
//  CityManager.swift
//  WeatherForWeera
//
//  Created by Vazgen on 4/4/23.
//

import Foundation

final class CityManager {
    //MARK: - Static
    static var shared = CityManager()
    
    let baseURL = "https://openweathermap.org/data/2.5/find?q=%@&appid=439d4b804bc8187953eb36d2a8c26a02&units=metric"
    
    // MARK: - Init
    private init() {}
    
    func getCitiesWeathers(searchCity: String, success: @escaping (([WeatherData]) -> Void), failure: @escaping ((String) -> Void)) {
        let urlString = String(format: baseURL, searchCity)
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    failure("Error: \(error.localizedDescription)")
                    return
                }
                    
                guard let httpResponse = response as? HTTPURLResponse,
                      (200 ..< 300).contains(httpResponse.statusCode)
                else {
                    print("Invalid response from server")
                    failure("Invalid response from server")
                    return
                }
                    
                guard let data = data else {
                    failure("No data received")
                    return
                }
                    
                do {
                    let decoder = JSONDecoder()
                    let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                    success(weatherResponse.list)
                    print(weatherResponse)
                } catch {
                    failure("Error decoding JSON: \(error)")
                }
                    
                print(String(data: data, encoding: .utf8) ?? "Data is not a valid UTF-8 string")
            }
        }.resume()
    }
}
