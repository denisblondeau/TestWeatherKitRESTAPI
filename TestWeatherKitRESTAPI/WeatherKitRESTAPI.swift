//
//  WeatherKitRESTAPI.swift
//  TestWeatherKitRESTAPI
//
//  Created by Denis Blondeau on 2022-06-20.
//

import Foundation

// MARK: - CurrentWeather - Ref: https://developer.apple.com/documentation/weatherkitrestapi/currentweather
/// The current weather conditions for the specified location.
struct CurrentWeather: Codable {
    /// The current weather for the requested location.
    let currentWeather: CurrentWeatherData
}

// MARK: - CurrentWeatherData - Ref: https://developer.apple.com/documentation/weatherkitrestapi/currentweather/currentweatherdata
/// The current weather object.
struct CurrentWeatherData: Codable {
    /// Weather dataset name.
    let name: String?
    /// Descriptive information about the weather data.
    let metadata: Metadata
    /// The date and time.
    let asOf: Date
    /// The percentage of the sky covered with clouds during the period, from 0 to 1.
    let cloudCover: Double?
    /// An enumeration value indicating the condition at the time.
    let conditionCode: String
    /// A Boolean value indicating whether there is daylight.
    let daylight: Bool?
    ///  The relative humidity, from 0 to 1.
    let humidity: Double
    /// The precipitation intensity in millimeters per hour.
    let precipitationIntensity: Int
    /// The sea level air pressure in millibars.
    let pressure: Double
    /// The direction of change of the sea level air pressure.
    let pressureTrend: PressureTrend
    /// The current temperature.
    let temperature: Double
    ///  The feels-like temperature when factoring wind and humidity.
    let temperatureApparent: Double
    /// The temperature at which relative humidity is 100%.
    let temperatureDewPoint: Double
    /// The level of ultraviolet radiation.
    let uvIndex: Int
    /// The distance at which terrain is visible.
    let visibility: Double
    /// The direction of the wind.
    let windDirection: Int?
    /// The maximum wind gust speed.
    let windGust: Double?
    ///  The wind speed.
    let windSpeed: Double
}

// MARK: - Metadata - Ref: https://developer.apple.com/documentation/weatherkitrestapi/metadata
/// Descriptive information about the weather data.
struct Metadata: Codable {
    /// The URL of the legal attribution for the data source.
    let attributionURL: String?
    /// The time when the weather data is no longer valid.
    let expireTime: Date
    /// The ISO language code for localizable fields.
    let language: String?
    /// The latitude of the relevant location.
    let latitude: Double
    /// The longitude of the relevant location.
    let longitude: Double
    /// The URL of a logo for the data provider.
    let providerLogo: String?
    /// The name of the data provider.
    let providerName: String?
    /// The time the weather data was procured.
    let readTime: Date
    /// The time the provider reported the weather data.
    let reportedTime: Date?
    /// The weather data is temporarily unavailable from the provider.
    let temporarilyUnavailable: Bool?
    /// The system of units that the weather data is reported in. This is set to metric.
    let units: UnitsSystem?
    /// The data format version.
    let version: Int
}

// MARK: - PressureTrend - Ref: https://developer.apple.com/documentation/weatherkitrestapi/pressuretrend
/// The direction of change of the sea level air pressure.
enum PressureTrend: String, Codable {
    // The sea level air pressure is increasing.
    case rising
    // The sea level air pressure is decreasing.
    case falling
    // The sea level air pressure is remaining about the same.
    case steady
}

// MARK: UnitsSystem - Ref: https://developer.apple.com/documentation/weatherkitrestapi/unitssystem
// The system of units that the weather data is reported in.
enum UnitsSystem: String, Codable {
    // The metric system.
    case m
}


