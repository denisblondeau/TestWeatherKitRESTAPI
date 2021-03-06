//
//  WeatherModel.swift
//  TestWeatherKitRESTAPI
//
//  Created by Denis Blondeau on 2022-06-20.
//

import Combine
import Foundation
import SwiftJWT

class WeatherModel: ObservableObject {
    
    private struct MyClaims: Claims {
        let iss: String
        let iat: Date
        let exp: Date
        let sub: String
    }
    
    // Apple Developer's Team ID.
    private let teamID = "YOUR TEAMID"
    // WeatherKit Service ID
    private let serviceID = "YOUR SERVICEID"
    // WeatherKit Key ID.
    private let keyID = "YOUR WEATHERKIT KEY ID"
    // Private Key extracted from the .p8 file.
    private let secret = """
            PASTE EVERYTHING FROM YOUR .P8 FILE HERE
           """
    
   
    
    @Published private(set) var availableDataSets: Set<DataSet>?
    @Published private(set) var weatherData: Weather?
    @Published private(set) var cityName = ""
    @Published var authorizationDenied = false
  
    private let locationManager = LocationManager()
    private var cancellable: AnyCancellable?
    
    func getWeatherData() async {
        
        // Confirm that this application is authorized to access the device's location.
        cancellable = locationManager.getAuthorizationStatus().sink(receiveCompletion: { _ in },
                                                                    receiveValue: { authorizationStatus in
            switch authorizationStatus {
            case .denied, .restricted:
                self.authorizationDenied = true
                return
            // If this is the first time this application receives permission to use the device's location, get the weather data.
            case .authorizedAlways, .authorizedWhenInUse:
                Task {
                    await self.getWeatherData()
                    return
                }
            default:
                break
            }
       
        })
        
        do {
            let locationData = try await locationManager.getLocationData()
            DispatchQueue.main.async {
                self.cityName = locationData.city
            }
            await processLocationData(locationData)
        } catch {
            print(error)
        }
        
        func processLocationData(_ locationData: LocationData) async {
            let header = Header(kid: keyID)
            let claims = MyClaims(iss: teamID, iat: Date(), exp: Date(timeIntervalSinceNow: 60), sub: serviceID)
            
            // Create and sign the JSON Web Token (JWT).
            var myJWT = JWT(header: header, claims: claims)
            let privateKey = Data(secret.utf8)
            let signer = JWTSigner.es256(privateKey: privateKey)
            guard let signedJWT = try? myJWT.sign(using: signer) else {
                print("Error: Cannot sign JSON Web Token.")
                return
            }
            
            // Determine the data sets available for the specified location.
            guard let url = URL(string: "https://weatherkit.apple.com/api/v1/availability/\(locationData.latitude)/\(locationData.longitude)?country=\(locationData.countryCode)") else {
                print("Error: Cannot generate a valid URL.")
                return
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("Bearer \(signedJWT)", forHTTPHeaderField: "Authorization")
            
            var sets = ""
            
            do {
                if let dataSets =  try await getData(for: urlRequest, type: availableDataSets) {
                    DispatchQueue.main.async {
                        self.availableDataSets = dataSets
                    }
                    
                    // Obtain weather data for the specified location and all the available data sets.
                    for dataset in dataSets {
                        sets += dataset.rawValue + ","
                    }
                    sets = String(sets.dropLast())
                }
                
            } catch {
                print ("*** Error retrieving weather data sets: \(error.localizedDescription)")
            }
            
            // *** REST API documentation indicates that "countryCode" is to be used as query parameter but "country" is really the right keyword. ***
            guard let url = URL(string: "https://weatherkit.apple.com/api/v1/weather/\(locationData.languageTag)/\(locationData.latitude)/\(locationData.longitude)?country=\(locationData.countryCode)&dataSets=\(sets)&timezone=\(locationData.timezoneName)") else {
                print("Error: Cannot generate a valid URL.")
                return
            }
            
            urlRequest.url = url
            
            // Get the data and also print out its JSON representation to the console.
            
            do {
                if let weather = try await getData(for: urlRequest, type: self.weatherData, printJSON: true) {
                    
                    DispatchQueue.main.async {
                        self.weatherData = weather
                    }
                }
            } catch {
                
                print ("*** Error retrieving weather data: \(error.localizedDescription)")
            }
        }
    }
}


// Retrieve and convert web data to an object.
/// - Parameters:
///   - urlRequest: URL Request.
///   - type: Type of object that will get the decoded data.
///   - printJSON: Set to true to print out to the console the JSON data received.
/// - Returns: Object of type T.
func getData<T: Decodable>(for request: URLRequest, type: T, printJSON: Bool = false) async throws -> T {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse,
          (200..<400).contains(httpResponse.statusCode) else {
        throw URLError(.badServerResponse)
    }
    
    if printJSON {
        if let jsonString = String(data: data, encoding: .utf8) {
            print("**** Weather data as JSON: \(jsonString)")
        } else {
            print("**** CANNOT DECODE AND PRINT JSON DATA ****")
        }
    }
    
    do {
        let object = try decoder.decode(T.self, from: data)
        return object
        
    } catch {
        throw(error)
        
    }
    
    
    
}

