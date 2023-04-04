//
//  WeatherViewController.swift
//  WeatherForWeera
//
//  Created by Vazgen on 4/4/23.
//

import UIKit

final class WeatherViewController: BaseViewController {
    // MARK: - IBOutlet
    @IBOutlet private var conditionImageView: UIImageView!
    @IBOutlet private var temperatureLabel: UILabel!
    @IBOutlet private var cityLabel: UILabel!

    // MARK: - Live cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDate()
    }

    // MARK: - IBAction
    @IBAction func openSearchAction(_ sender: UIButton) {
        guard let searchVC = SearchViewController.searchViewController else { return }
        searchVC.citySelected = { [weak self] city in
            guard let self, let city else { return }
            UserDefaults.standard.setValue(["name": city.name, "temp": city.main.temp.celsiusValueFromKelvin], forKey: "lastCityDict")
            self.cityLabel.text = city.name
            self.changeTemperatureImageIfNeeded(temp: city.main.temp.celsiusValueFromKelvin)
            self.temperatureLabel.text = String(city.main.temp.celsiusValueFromKelvin)
        }
        present(searchVC, animated: true)
    }
}

// MARK: - private
private extension WeatherViewController {
    func changeTemperatureImageIfNeeded(temp: Int) {
        conditionImageView.image = UIImage(systemName: temp > 0 ? "sun.max" : "cloud.heavyrain")
    }

    func setupDate() {
        if isInternetConnected() {
            getLocalWheather()
        } else {
            let lastCityDict = UserDefaults.standard.value(forKey: "lastCityDict") as? [String: Any]
            cityLabel.text = lastCityDict?["name"] as? String ?? ""
            let temp = lastCityDict?["temp"] as? Int ?? 0
            temperatureLabel.text = String(temp)
            changeTemperatureImageIfNeeded(temp: temp)
            conditionImageView.alpha = 1
        }
    }

    func getLocalWheather() {
        var regionName = ""
        if let regionCode = Locale.current.regionCode {
            regionName = (Locale.current as NSLocale).localizedString(forLocaleIdentifier: regionCode)
        }

        regionName = regionName.isEmpty ? "Yerevan" : regionName
        showLoader()
        CityManager.shared.getCitiesWeathers(searchCity: regionName) { [weak self] cityModels in
            guard let self, let firstCity = cityModels.first else { return }
            self.cityLabel.text = firstCity.name
            self.changeTemperatureImageIfNeeded(temp: firstCity.main.temp.celsiusValueFromKelvin)
            self.temperatureLabel.text = String(firstCity.main.temp.celsiusValueFromKelvin)
            self.conditionImageView.alpha = 1
            self.hideLoader()
        } failure: { [weak self] errorMessage in
            guard let self else { return }
            self.showError(title: errorMessage)
            self.hideLoader()
        }
    }
}
