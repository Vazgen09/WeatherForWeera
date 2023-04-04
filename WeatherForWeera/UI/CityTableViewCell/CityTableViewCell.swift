//
//  CityTableViewCell.swift
//  WeatherForWeera
//
//  Created by Vazgen on 4/4/23.
//

import UIKit

final class CityTableViewCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var labelBackgroundView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabelBackgroundView()
    }

    func configure(city: String) {
        cityLabel.text = city
    }

    private func setupLabelBackgroundView() {
        labelBackgroundView.layer.cornerRadius = 10
        labelBackgroundView.layer.borderWidth = 1
        labelBackgroundView.layer.borderColor = UIColor.systemBackground.cgColor
    }
}
