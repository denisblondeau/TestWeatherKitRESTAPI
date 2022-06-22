//
//  CurrentWeatherModel.swift
//  TestWeatherKitRESTAPI
//
//  Created by Denis Blondeau on 2022-06-20.
//

import Combine
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
    
    @Published private(set) var availableDataSets: Set<DataSet>?
    @Published private(set) var weatherData: Weather?
    private var subscriptions = Set<AnyCancellable>()
    
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
        
        // Determine the data sets available for the specified location.
        guard let url = URL(string: "https://weatherkit.apple.com/api/v1/availability/\(latitude)/\(longitude)?country=US") else {
            print("Error: Cannot generate a valid URL.")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(signedJWT)", forHTTPHeaderField: "Authorization")
        
        getData(for: urlRequest, type: availableDataSets)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    break
                }
            } receiveValue: { dataSets in
                if let dataSets = dataSets {
                    self.availableDataSets = dataSets
                    
                    // Obtain weather data for the specified location and all the available data sets.
                    var sets = ""
                    for dataset in dataSets {
                        sets += dataset.rawValue + ","
                        
                    }
                    sets = String(sets.dropLast())
                    
                    guard let url = URL(string: "https://weatherkit.apple.com/api/v1/weather/en-US/\(latitude)/\(longitude)?countryCode=US&dataSets=\(sets)&timezone=PDT") else {
                        print("Error: Cannot generate a valid URL.")
                        return
                    }
                    
                    urlRequest.url = url
                    
                    // Get the data and also print out its JSON representation to the console.
                    getData(for: urlRequest, type: self.weatherData, printJSON: true)
                        .sink { completion in
                            switch completion {
                            case .failure(let error):
                                print(error)
                            case .finished:
                                break
                            }
                        } receiveValue: { weather in
                            if let weather = weather {
                                self.weatherData = weather
                            }
                        }
                        .store(in: &self.subscriptions)
                }
            }
            .store(in: &subscriptions)
    }
}

/// Retrieves and convert web data to an object.
/// - Parameters:
///   - urlRequest: URL Request.
///   - type: Type of object that will get the decoded data.
///   - printJSON: Set to true to print out to the console the JSON data received.
/// - Returns: Object and possibly an error.
func getData<T: Decodable>(for urlRequest: URLRequest, type: T, printJSON: Bool = false) -> AnyPublisher<T, Error> {
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    return URLSession.shared.dataTaskPublisher(for: urlRequest)
        .retry(1)
        .map(\.data)
        .handleEvents(receiveOutput: { data in
            if printJSON {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("**** Weather data as JSON: \(jsonString)")
                } else {
                    print("**** CANNOT DECODE AND PRINT JSON DATA ****")
                }
            }
        })
        .decode(type: T.self, decoder: decoder)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    
}
