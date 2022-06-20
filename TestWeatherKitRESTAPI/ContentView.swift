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
            if let weatherData = model.weatherData, let jsonString = model.jsonString {
                VStack {
                    Text("Current temperature at Apple Park: \(String(weatherData.currentWeather.temperature))")
                        .padding()
                    
                    Text("ALL CURRENT WEATHER DATA: \(jsonString)")
                        .padding()
                       
                }
              
            } else {
                Text("No weather")
            }
            
            HStack {
                Image(systemName: "applelogo")
                Text("Weather")
            }
            
            if let attributionURL = model.weatherData?.currentWeather.metadata.attributionURL {
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
