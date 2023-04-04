//
//  WeatherForWeeraTests.swift
//  WeatherForWeeraTests
//
//  Created by Vazgen on 4/3/23.
//

import XCTest
@testable import WeatherForWeera

final class WeatherForWeeraTests: XCTestCase {
    var jsonData: Data?
    var expectedJSONString: String = ""

    override func setUpWithError() throws {
        expectedJSONString = "{\"message\":\"accurate\",\"cod\":\"200\",\"count\":1,\"list\":[{\"wind\":{\"speed\":1.54,\"deg\":150},\"clouds\":{\"all\":3},\"dt\":1680588543,\"id\":616052,\"coord\":{\"lat\":40.181100000000001,\"lon\":44.513599999999997},\"main\":{\"temp_max\":285.24000000000001,\"humidity\":67,\"feels_like\":284.25,\"temp_min\":285.24000000000001,\"temp\":285.24000000000001,\"pressure\":1019},\"weather\":[{\"id\":800,\"main\":\"Clear\",\"icon\":\"01d\",\"description\":\"clear sky\"}],\"sys\":{\"country\":\"AM\"},\"name\":\"Yerevan\"}]}"

        jsonData = """
        {
            "message": "accurate",
            "cod": "200",
            "count": 2,
            "list": [
                {
                    "id": 616052,
                    "name": "Yerevan",
                    "coord": {
                        "lat": 40.1811,
                        "lon": 44.5136
                    },
                    "main": {
                        "temp": 285.24,
                        "feels_like": 284.25,
                        "temp_min": 285.24,
                        "temp_max": 285.24,
                        "pressure": 1019,
                        "humidity": 67
                    },
                    "dt": 1680588543,
                    "wind": {
                        "speed": 1.54,
                        "deg": 150
                    },
                    "sys": {
                        "country": "AM"
                    },
                    "rain": null,
                    "snow": null,
                    "clouds": {
                        "all": 3
                    },
                    "weather": [
                        {
                            "id": 800,
                            "main": "Clear",
                            "description": "clear sky",
                            "icon": "01d"
                        }
                    ]
                },
                {
                    "id": 616051,
                    "name": "Yerevan",
                    "coord": {
                        "lat": 40.1833,
                        "lon": 44.5
                    },
                    "main": {
                        "temp": 285.14,
                        "feels_like": 284.14,
                        "temp_min": 285.14,
                        "temp_max": 285.14,
                        "pressure": 1019,
                        "humidity": 67
                    },
                    "dt": 1680588326,
                    "wind": {
                        "speed": 1.54,
                        "deg": 150
                    },
                    "sys": {
                        "country": "AM"
                    },
                    "rain": null,
                    "snow": null,
                    "clouds": {
                        "all": 3
                    },
                    "weather": [
                        {
                            "id": 800,
                            "main": "Clear",
                            "description": "clear sky",
                            "icon": "01d"
                        }
                    ]
                }
            ]
        }
        """.data(using: .utf8)
    }

    override func tearDownWithError() throws {
        jsonData = nil
        expectedJSONString = ""
    }
        

    func testDecodingInvalidData() {
        let invalidData = Data("{}".utf8)
        XCTAssertThrowsError(try JSONDecoder().decode(WeatherResponse.self, from: invalidData))
    }

    func testDecodingValidData() {
        XCTAssertNoThrow(try JSONDecoder().decode(WeatherResponse.self, from: jsonData!))
    }
    
    func testEncoding() {
            // Arrange
            let coordinates = Coordinates(lat: 40.1811, lon: 44.5136)
            let mainInfo = MainInfo(temp: 285.24, feelsLike: 284.25, tempMin: 285.24, tempMax: 285.24, pressure: 1019, humidity: 67)
            let windInfo = WindInfo(speed: 1.54, deg: 150)
            let sysInfo = SysInfo(country: "AM")
            let cloudInfo = CloudInfo(all: 3)
            let weatherDescription = WeatherDescription(id: 800, main: "Clear", description: "clear sky", icon: "01d")
            let weatherInfo = WeatherData(id: 616052, name: "Yerevan", coord: coordinates, main: mainInfo, dt: 1680588543, wind: windInfo, sys: sysInfo, rain: nil, snow: nil, clouds: cloudInfo, weather: [weatherDescription])
            let weatherResponse = WeatherResponse(message: "accurate", cod: "200", count: 1, list: [weatherInfo])
            
            let encoder = JSONEncoder()

            // Act
            guard let jsonData = try? encoder.encode(weatherResponse) else {
                XCTFail("Failed to encode WeatherResponse to JSON")
                return
            }
            
            // Assert
            let jsonString = String(data: jsonData, encoding: .utf8)
            XCTAssertNotNil(jsonString)
            
            XCTAssertEqual(jsonString, expectedJSONString)
        }

    func testPerformanceExample() throws {
        let expectation = self.expectation(description: "Weather API request should complete")

        self.measure {
            CityManager.shared.getCitiesWeathers(searchCity: "Yerevan") { _ in
                expectation.fulfill()
            } failure: { _ in
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)

    }

}
