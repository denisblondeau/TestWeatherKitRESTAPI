//
//  LocationManager.swift
//  TestWeatherKitRESTAPI
//
//  Created by Denis Blondeau on 2022-07-22.
//
// Class code is based on https://betterprogramming.pub/convert-your-swift-facades-to-the-new-async-await-syntax-using-continuations-d4a7bda4611b

import Combine
import CoreLocation


final class LocationManager: NSObject {
    
    private typealias LocationDataCheckedThrowingContinuation = CheckedContinuation<LocationData, Error>
    private lazy var manager = CLLocationManager()
    private var locationDataCheckedThrowingContinuation: LocationDataCheckedThrowingContinuation?
    
    func getLocationData() async throws -> LocationData {
        
        return try await withCheckedThrowingContinuation({ [weak self] (continuation: LocationDataCheckedThrowingContinuation) in
            guard let self = self else {
                return
            }
            
            self.locationDataCheckedThrowingContinuation = continuation
            
            self.manager.delegate = self
            self.manager.desiredAccuracy = kCLLocationAccuracyBest
            self.manager.requestWhenInUseAuthorization()
            self.manager.startUpdatingLocation()
        })
    }
}


extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Only need to get initial location update.
        manager.stopUpdatingLocation()
        manager.delegate = nil
        
        let geoCoder = CLGeocoder()
        var countryCode = ""
        var city = ""
        var timezoneName = ""
        
        let latitude = locations.last?.coordinate.latitude.description ?? ""
        let longitude = locations.last?.coordinate.longitude.description ?? ""
        
        geoCoder.reverseGeocodeLocation(locations.last!) { placemarks, error in
            if let placemark = placemarks?[0] {
                countryCode = placemark.isoCountryCode ?? ""
                city = placemark.locality ?? ""
                timezoneName = placemark.timeZone?.identifier ?? ""
            }
            
            // Retrieve primary language on device running this application.
            let languageTag = UserDefaults.standard.stringArray(forKey: "AppleLanguages")![0]
            
            let locationData = LocationData(latitude: latitude, longitude: longitude, countryCode: countryCode, city: city, timezoneName: timezoneName, languageTag: languageTag)
            
            self.locationDataCheckedThrowingContinuation?.resume(returning: locationData)
            self.locationDataCheckedThrowingContinuation = nil
        }
    }
    
    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        locationDataCheckedThrowingContinuation?.resume(throwing: error)
        locationDataCheckedThrowingContinuation = nil
    }

}

struct LocationData {
    var latitude: String
    var longitude: String
    var countryCode: String
    var city: String
    var timezoneName: String
    var languageTag: String
}
