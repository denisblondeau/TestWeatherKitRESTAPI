//
//  CurrentWeatherModel.swift
//  TestWeatherKitRESTAPI
//
//  Created by Denis Blondeau on 2022-06-20.
//

import Foundation
import SwiftJWT

class CurrentWeatherModel: ObservableObject {
    
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
    
    @Published private(set) var weatherData: CurrentWeather?
    @Published private(set) var jsonString: String?
    
    
    init() {
        
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
        
        // Apple Park location.
        let latitude = "37.334"
        let longitude = "-122.008"
        
        guard let url = URL(string: "https://weatherkit.apple.com/api/v1/weather/en-US/\(latitude)/\(longitude)?countryCode=US&dataSets=currentWeather&timezone=PDT") else {
            print("Error: Cannot generate a valid URL.")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(signedJWT)", forHTTPHeaderField: "Authorization")
        
        // Get the weather data.
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if let error = error {
                print("HTTPS Request Failed: \(error.localizedDescription)")
                return
            }
            
            if let response = response {
                let statusCode = (response as! HTTPURLResponse).statusCode
                if statusCode != 200 {
                    print("Error: Response Code - \(statusCode)")
                    return
                }
            }
            
            guard let data = data else {
                print("Error: No weather data received.")
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                
                    self.weatherData = try decoder.decode(CurrentWeather.self, from: data)
        
                } catch {
                    print("Error decoding current weather from data: \(error.localizedDescription)")
                }
                
                self.jsonString = String(data: data, encoding: .utf8)
            }
            
        }
        
        task.resume()
        
        
        
    }
    
}


