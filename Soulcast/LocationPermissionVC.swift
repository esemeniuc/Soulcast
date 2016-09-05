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
  
  init() {
    super.init(title: locationTitle, description: locationDescription) { }
    locationManager.delegate = self
    requestAction = { MapVC.systemAskLocationPermission(self.locationManager) }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}


extension LocationPermissionVC: CLLocationManagerDelegate {
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    switch status {
    case .NotDetermined:
      break
    case .AuthorizedWhenInUse:
      // If authorized when in use
      break
    case .AuthorizedAlways:
      gotPermission()
      break
    case .Restricted:
      // If restricted by e.g. parental controls. User can't enable Location Services
      break
    case .Denied:
      deniedPermission()
      break
    }
  }
  
}
