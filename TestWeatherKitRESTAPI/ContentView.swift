//
//  ContentView.swift
//  TestWeatherKitRESTAPI
//
//  Created by Denis Blondeau on 2022-06-20.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var model = WeatherModel()
    private let weatherAPIDateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .full
        result.timeStyle = .medium
        result.locale = Locale.current
        result.timeZone = TimeZone.current
        return result
    }()
    
    
    var body: some View {
        VStack {
            
            if let dataSets = model.availableDataSets {
                VStack {
                    Text("Available Data Sets:")
                        .foregroundColor(.green)
                    ForEach(Array(dataSets), id:\.self) { item in
                        Text(item.rawValue)
                    }
                }
            }
            
            if let currentWeather = model.weatherData?.currentWeather {
                
                Text("Weather data is current as of:\n \(weatherAPIDateFormatter.string(from: currentWeather.asOf))\n(Local Time)")
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("Current temperature at Apple Park:\n \(String(currentWeather.temperature))")
                    .multilineTextAlignment(.center)
                    .padding()
                
            }
            
            if let forecastDaily = model.weatherData?.forecastDaily {
                Text("Tomorrow's condition code:\n \(forecastDaily.days[1].conditionCode)")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            if let forecastHourly = model.weatherData?.forecastHourly {
                Text("UV Index at 00h00:\n \(forecastHourly.hours[0].uvIndex)")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            if let forecastNextHour = model.weatherData?.forecastNextHour, (forecastNextHour.summary.count > 0) {
                Text("Type of precipitation forecasted for the next hour:\n \(forecastNextHour.summary[0].condition.rawValue)")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            if let detailsURL = model.weatherData?.weatherAlerts?.detailsUrl {
                Link("Weather Alerts", destination: URL(string: detailsURL)!)
                    .padding()
                
            }
           
            HStack {
                Image(systemName: "applelogo")
                Text("Weather")
            }
            
            if let attributionURL = model.weatherData?.currentWeather?.metadata.attributionURL {
                Link("Legal - Data Sources", destination: URL(string: attributionURL)!)
            }
        }
        .task {
            await model.getWeatherData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
