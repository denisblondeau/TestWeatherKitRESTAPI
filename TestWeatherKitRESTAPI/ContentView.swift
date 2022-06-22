//
//  ContentView.swift
//  TestWeatherKitRESTAPI
//
//  Created by Denis Blondeau on 2022-06-20.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var model = CurrentWeatherModel()
    
    
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
                
                Text("Current temperature at Apple Park: \(String(currentWeather.temperature))")
                    .padding()
            }
            
            if let forecastDaily = model.weatherData?.forecastDaily {
                Text("Tomorrow's condition code: \(forecastDaily.days[1].conditionCode)")
                    .padding()
            }
           
            if let forecastHourly = model.weatherData?.forecastHourly {
                Text("UV Index at 00h00: \(forecastHourly.hours[0].uvIndex)")
                    .padding()
            }
            
            if let forecastNextHour = model.weatherData?.forecastNextHour, (forecastNextHour.summary.count > 0) {
                Text("Type of precipitation forecasted for the next hour:  \(forecastNextHour.summary[0].condition.rawValue)")
                    .padding()
            }
            
            if let weatherAlerts = model.weatherData?.weatherAlerts {
                Text("Description of first weather alert: \(weatherAlerts.alerts[0].description)")
            }
            
            HStack {
                Image(systemName: "applelogo")
                Text("Weather")
            }
            
            if let attributionURL = model.weatherData?.currentWeather?.metadata.attributionURL {
                Link("Legal - Data Sources", destination: URL(string: attributionURL)!)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
