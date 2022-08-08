//
//  WeatherKitRESTAPI.swift
//  TestWeatherKitRESTAPI
//
//  Created by Denis Blondeau on 2022-06-20.
//

import Foundation

/// MARK: - Weather - Ref: https://developer.apple.com/documentation/weatherkitrestapi/weather
struct Weather: Codable {
    /// The current weather for the requested location.
    let currentWeather: CurrentWeather?
    /// The daily forecast for the requested location.
    let forecastDaily: DailyForecast?
    /// The hourly forecast for the requested location.
    let forecastHourly: HourlyForecast?
    /// The next hour forecast for the requested location.
    let forecastNextHour: NextHourForecast?
    /// Weather alerts for the requested location.
    let weatherAlerts: WeatherAlertCollection?
    
}

// MARK: - CurrentWeather - Ref: https://developer.apple.com/documentation/weatherkitrestapi/currentweather
/// The current weather conditions for the specified location.
struct CurrentWeather: ProductData, Codable {
    var name: String
    var metadata: Metadata
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
    let precipitationIntensity: Double
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

// MARK: - DailyForecast - Ref: https://developer.apple.com/documentation/weatherkitrestapi/dailyforecast
/// A collection of day forecasts for a specified range of days.
struct DailyForecast: ProductData, Codable {
    var name: String
    var metadata: Metadata
    /// An array of the day forecast weather conditions.
    let days: [DayWeatherConditions]
    /// A URL that provides more information about the forecast.
    let learnMoreURL: String?
}

// MARK: - HourlyForecast - Ref: https://developer.apple.com/documentation/weatherkitrestapi/hourlyforecast
/// A collection of hour forecasts for a specified range of hours.
struct HourlyForecast: ProductData, Codable {
    var name: String
    var metadata: Metadata
    /// An array of hourly forecasts.
    let hours: [HourWeatherConditions]
}

// MARK: - NextHourForecast - Ref: https://developer.apple.com/documentation/weatherkitrestapi/weather
/// A minute-by-minute forecast for the next hour.
struct NextHourForecast: ProductData, Codable {
    var name: String
    var metadata: Metadata
    /// The time the forecast ends.
    let forecastEnd: Date?
    /// The time the forecast starts.
    let forecastStart: Date?
    /// An array of the forecast minutes.
    let minutes: [ForecastMinute]
    /// An array of the forecast summaries.
    let summary: [ForecastPeriodSummary]
}

// MARK: - WeatherAlertCollection - Ref: https://developer.apple.com/documentation/weatherkitrestapi/weatheralertcollection
/// A collection of severe weather alerts for a specified location.
struct WeatherAlertCollection: ProductData, Codable {
    var name: String
    var metadata: Metadata
    /// An array of weather alert summaries.
    let alerts: [WeatherAlertSummary]
    /// A URL that provides more information about the alerts.
    let detailsUrl: String?
}

// MARK: - WeatherAlertSummary - Ref: https://developer.apple.com/documentation/weatherkitrestapi/weatheralertsummary
/// Detailed information about the weather alert.
struct WeatherAlertSummary: Codable {
    /// An official designation of the affected area.
    let areaId: String?
    /// A human-readable name of the affected area.
    let areaName: String?
    /// How likely the event is to occur.
    let certainty: Certainty
    /// The ISO code of the reporting country.
    let countryCode: String
    /// A human-readable description of the event.
    let description: String
    /// The URL to a page containing detailed information about the event.
    let detailsUrl: String?
    /// The time the event went into effect.
    let effectiveTime: Date
    /// The time when the underlying weather event is projected to end.
    let eventEndTime: Date?
    /// The time when the underlying weather event is projected to start.
    let eventOnsetTime: Date?
    /// The time when the event expires.
    let expireTime: Date
    /// A unique identifier of the event.
    let id: UUID
    /// The time that event was issued by the reporting agency.
    let issuedTime: Date
    /// An array of recommended actions from the reporting agency.
    let responses: [ResponseType]
    /// The level of danger to life and property.
    let severity: Severity
    /// The name of the reporting agency.
    let source: String
    /// An indication of urgency of action from the reporting agency.
    let urgency: Urgency?
}

// MARK: - ForecastPeriodSummary - Ref: https://developer.apple.com/documentation/weatherkitrestapi/forecastminute
/// The summary for a specified period in the minute forecast.
struct ForecastPeriodSummary: Codable {
    ///The type of precipitation forecasted.
    let condition: PrecipitationType
    /// he end time of the forecast.
    let endTime: Date?
    /// The probability of precipitation during this period.
    let precipitationChance: Double
    /// The precipitation intensity in millimeters per hour.
    let precipitationIntensity: Double
    /// The start time of the forecast.
    let startTime: Date
}

// MARK: - ForecastMinute - Ref: https://developer.apple.com/documentation/weatherkitrestapi/forecastminute
struct ForecastMinute: Codable {
    /// The probability of precipitation during this minute.
    let precipitationChance: Double
    /// The precipitation intensity in millimeters per hour.
    let precipitationIntensity: Double
    /// The start time of the minute.
    let startTime: Date
}

// MARK: - DayWeatherConditions - Ref: https://developer.apple.com/documentation/weatherkitrestapi/dayweatherconditions
/// The historical or forecasted weather conditions for a specified day.
struct DayWeatherConditions: Codable {
    /// An enumeration value indicating the condition at the time.
    let conditionCode: String
    /// The day part forecast between 7 AM and 7 PM for the day.
    let daytimeForecast: DayPartForecast?
    /// The ending date and time of the day.
    let forecastEnd: Date
    /// The starting date and time of the day.
    let forecastStart: Date
    /// The maximum ultraviolet index value during the day.
    let maxUvIndex: Int
    /// The phase of the moon on the specified day.
    let moonPhase: MoonPhase
    /// The time of moonrise on the specified day.
    let moonrise: Date?
    /// The time of moonset on the specified day.
    let moonset: Date?
    /// The day part forecast between 7 PM and 7 AM for the overnight.
    let overnightForecast: DayPartForecast?
    ///  The amount of precipitation forecasted to occur during the day, in millimeters.
    let precipitationAmount: Double
    /// The chance of precipitation forecasted to occur during the day.
    let precipitationChance: Double
    /// The type of precipitation forecasted to occur during the day.
    let precipitationType: PrecipitationType
    /// The depth of snow as ice crystals forecasted to occur during the day.
    let snowfallAmount: Double
    /// The time when the sun is at its lowest in the sky.
    let solarMidnight: Date?
    /// The time when the sun is at its highest in the sky.
    let solarNoon: Date?
    /// The time when the top edge of the sun reaches the horizon in the morning.
    let sunrise: Date?
    /// The time when the sun is 18 degrees below the horizon in the morning.
    let sunriseAstronomical: Date?
    /// The time when the sun is 6 degrees below the horizon in the morning.
    let sunriseCivil: Date?
    /// The time when the sun is 12 degrees below the horizon in the morning.
    let sunriseNautical: Date?
    /// The time when the top edge of the sun reaches the horizon in the evening.
    let sunset: Date?
    /// The time when the sun is 18 degrees below the horizon in the evening.
    let sunsetAstronomical: Date?
    /// The time when the sun is 6 degrees below the horizon in the evening.
    let sunsetCivil: Date?
    /// The time when the sun is 12 degrees below the horizon in the evening.
    let sunsetNautical: Date?
    /// The maximum temperature forecasted to occur during the day.
    let temperatureMax: Double
    /// The minimum temperature forecasted to occur during the day.
    let temperatureMin: Double
}

// MARK: - DayPartForecast - Ref: https://developer.apple.com/documentation/weatherkitrestapi/daypartforecast
/// A summary forecast for a daytime or overnight period.
struct DayPartForecast: Codable {
    /// The percentage of the sky covered with clouds during the period, from 0 to 1.
    let cloudCover: Double
    /// An enumeration value indicating the condition at the time.
    let conditionCode: String
    /// The ending date and time of the forecast.
    let forecastEnd: Date
    /// The starting date and time of the forecast.
    let forecastStart : Date
    /// The relative humidity during the period, from 0 to 1.
    let humidity: Double
    /// The amount of precipitation forecasted to occur during the period, in millimeters.
    let precipitationAmount: Double
    /// The chance of precipitation forecasted to occur during the period.
    let precipitationChance: Double
    /// The type of precipitation forecasted to occur during the period.
    let precipitationType: PrecipitationType
    /// The depth of snow as ice crystals forecasted to occur during the period.
    let snowfallAmount: Double
    /// The direction the wind is forecasted to come from during the period.
    let windDirection: Int?
    /// The average speed the wind is forecasted to be during the period.
    let windSpeed: Double
}

// MARK: - HourWeatherConditions - Ref: https://developer.apple.com/documentation/weatherkitrestapi/hourweatherconditions
/// The historical or forecasted weather conditions for a specified hour.
struct HourWeatherConditions: Codable {
    /// The percentage of the sky covered with clouds during the period, from 0 to 1.
    let cloudCover: Double
    /// An enumeration value indicating the condition at the time.
    let conditionCode: String
    /// Indicates whether the hour starts during the day or night.
    let daylight: Bool?
    /// The starting date and time of the forecast.
    let forecastStart: Date
    /// The relative humidity at the start of the hour, from 0 to 1.
    let humidity: Double
    /// The chance of precipitation forecasted to occur during the hour.
    let precipitationChance: Double
    /// The type of precipitation forecasted to occur during the period.
    let precipitationType: PrecipitationType
    /// The sea level air pressure in millibars.
    let pressure: Double
    /// The direction of change of the sea level air pressure.
    let pressureTrend: PressureTrend?
    /// The rate at which snow crystals are falling in millimeters per hour.
    let snowfallIntensity: Double?
    /// The temperature at the start of the hour.
    let temperature: Double
    /// The feels-like temperature when considering wind and humidity, at the start of the hour.
    let temperatureApparent: Double
    /// The temperature at which relative humidity is 100% at the start of the hour.
    let temperatureDewPoint: Double?
    /// The level of ultraviolet radiation at the start of the hour.
    let uvIndex: Int
    /// The distance at which terrain is visible at the start of the hour.
    let visibility: Double
    /// The direction of the wind at the start of the hour.
    let windDirection: Int?
    /// The maximum wind gust speed during the hour.
    let windGust: Double?
    /// The wind speed at the start of the hour.
    let windSpeed: Double
    /// The amount of precipitation forecasted to occur during period, in millimeters.
    let precipitationAmount: Double?
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

// MARK: - MoonPhase - Ref: https://developer.apple.com/documentation/weatherkitrestapi/moonphase
/// The shape of the moon as seen by an observer on the ground at a given time.
enum MoonPhase: String, Codable {
    /// The moon isn’t visible.
    case new
    /// Approximately half of the moon is visible, and increasing in size.
    case firstQuarter
    /// The entire disc of the moon is visible.
    case full
    /// More than half of the moon is visible, and decreasing in size.
    case waningGibbous
    /// Approximately half of the moon is visible, and decreasing in size.
    case thirdQuarter
    /// A crescent-shaped sliver of the moon is visible, and decreasing in size.
    case waningCrescent
    /// A crescent-shaped sliver of the moon is visible, and increasing in size.
    case waxingCrescent
    /// More than half of the moon is visible, and increasing in size.
    case waxingGibbous
}

// MARK: - PrecipitationType - Ref: https://developer.apple.com/documentation/weatherkitrestapi/precipitationtype
/// The type of precipitation forecasted to occur during the day.
enum PrecipitationType: String, Codable {
    /// No precipitation is occurring.
    case clear
    /// An unknown type of precipitation is occuring.
    case precipitation
    /// Rain or freezing rain is falling.
    case rain
    /// Snow is falling.
    case snow
    /// Sleet or ice pellets are falling.
    case sleet
    /// Hail is falling.
    case hail
    /// Winter weather (wintery mix or wintery showers) is falling.
    case mixed
}

// MARK: - PressureTrend - Ref: https://developer.apple.com/documentation/weatherkitrestapi/pressuretrend
/// The direction of change of the sea level air pressure.
enum PressureTrend: String, Codable {
    /// The sea level air pressure is decreasing.
    case falling
    /// The sea level air pressure is increasing.
    case rising
    /// The sea level air pressure is remaining about the same.
    case steady
}

// MARK: - UnitsSystem - Ref: https://developer.apple.com/documentation/weatherkitrestapi/unitssystem
/// The system of units that the weather data is reported in.
enum UnitsSystem: String, Codable {
    /// The metric system.
    case m
}

// MARK: - Certainty - Ref: https://developer.apple.com/documentation/weatherkitrestapi/certainty
/// How likely the event is to occur.
enum Certainty: String, Codable {
    /// The event has already occurred or is ongoing.
    case observed
    /// The event is likely to occur (greater than 50% probability).
    case likely
    /// The event is unlikley to occur (less than 50% probability).
    case possible
    /// The event is not expected to occur (approximately 0% probability).
    case unlikely
    /// It is unknown if the event will occur.
    case unknown
}

// MARK: - ResponseType - Ref: https://developer.apple.com/documentation/weatherkitrestapi/responsetype
/// The recommended action from a reporting agency.
enum ResponseType: String, Codable {
    /// Take shelter in place.
    case shelter
    /// Relocate.
    case evacuate
    /// Make preparations.
    case prepare
    /// Execute a pre-planned activity.
    case execute
    /// Avoid the event.
    case avoid
    /// Monitor the situation.
    case monitor
    /// Assess the situation.
    case assess
    /// The event no longer poses a threat.
    case allClear
    /// No action recommended.
    case none
}

// MARK: - Severity - Ref: https://developer.apple.com/documentation/weatherkitrestapi/severity
/// The level of danger to life and property.
enum Severity: String, Codable {
    /// Extraordinary threat.
    case extreme
    /// Significant threat.
    case severe
    /// Possible threat.
    case moderate
    /// Minimal or no known threat.
    case minor
    /// Unknown threat.
    case unknown
}

// MARK: - Urgency - Ref: https://developer.apple.com/documentation/weatherkitrestapi/urgency
/// An indication of urgency of action from the reporting agency.
enum Urgency: String, Codable {
    /// Take responsive action immediately.
    case immediate
    /// Take responsive action in the next hour.
    case expected
    /// Take responsive action in the near future.
    case future
    /// Responsive action is no longer required.
    case past
    /// The urgency is unknown.
    case unknown
}

// MARK: - DataSet
/// Data sets available for the specified location.
enum DataSet: String, Codable, Comparable {
    
    /// The current weather for the requested location.
    case currentWeather
    /// The daily forecast for the requested location.
    case forecastDaily
    /// The hourly forecast for the requested location.
    case forecastHourly
    /// The next hour forecast for the requested location.
    case forecastNextHour
    /// Weather alerts for the requested location.
    case weatherAlerts
    
    static func < (lhs: DataSet, rhs: DataSet) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
}

// MARK: - ProductData
/// A base type for all weather data.
protocol ProductData: Codable {
    /// Weather data set name.
    var name: String { get }
    /// Descriptive information about the weather data.
    var metadata: Metadata { get }
   
}
