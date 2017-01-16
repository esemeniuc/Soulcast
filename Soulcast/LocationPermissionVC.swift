//
//  LocationPermissionVC.swift
//  Soulcast
//
//  Created by June Kim on 2016-09-05.
//  Copyright © 2016 Soulcast-team. All rights reserved.
//

import Foundation
import CoreLocation

class LocationPermissionVC: PermissionVC {
  let locationTitle = "Location Permission"
  let locationDescription = "This is a location-based app. We need your location so that you can catch souls around you"
  let locationManager = CLLocationManager()
  fileprivate static let hasLocationPermissionKey = "hasLocationPermission"
  

  
  init() {
    super.init(title: locationTitle, description: locationDescription) { }
    locationManager.delegate = self
    requestAction = { MapVC.systemAskLocationPermission(self.locationManager) }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

}

extension LocationPermissionVC: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .notDetermined:
      break
    case .authorizedWhenInUse:
      //TODO: test to get rid of ambiguity... what to do?
      break
    case .authorizedAlways:
      gotPermission()
      break
    case .restricted:
      break
    case .denied:
      deniedPermission()
      break
    }
  }
  
}
