//
//  SearchViewController.swift
//  WeatherForWeera
//
//  Created by Vazgen on 4/4/23.
//

import UIKit

final class SearchViewController: BaseViewController {
    // MARK: - IBOutlet
    @IBOutlet private var cityTableView: UITableView!
    @IBOutlet private var searchTextField: UITextField!

    // MARK: - Properties
    private var cities: [WeatherData] = []
    private var selectedCity: WeatherData?
    public var citySelected: ((WeatherData?) -> Void)?

    //MARK: - Static
    static var searchViewController: SearchViewController? = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        return vc
    }()

    override func viewWillDisappear(_ animated: Bool) {
        citySelected?(selectedCity)
    }

    // MARK: - IBAction
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        getSearchData(text: searchTextField.text)
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getSearchData(text: textField.text)
        return true
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as? CityTableViewCell else { return UITableViewCell() }
        cell.configure(city: cities[indexPath.row].name)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCity = cities[indexPath.row]
        dismiss(animated: true)
    }
}

// MARK: - Private
private extension SearchViewController {
    func getSearchData(text: String?) {
        cities.removeAll()
        showLoader()
        CityManager.shared.getCitiesWeathers(searchCity: text ?? "") { [weak self] cityModels in
            guard let self else { return }
            cityModels.forEach { city in
                if !self.cities.contains(where: { $0.name == city.name }) {
                    self.cities.append(city)
                }
            }
            self.cityTableView.reloadData()
            if self.cities.isEmpty {
                self.showError(title: "No Data")
            }
            self.hideLoader()
        } failure: { [weak self] errorMessage in
            guard let self else { return }
            self.showError(title: errorMessage)
            self.hideLoader()
        }
    }
}
