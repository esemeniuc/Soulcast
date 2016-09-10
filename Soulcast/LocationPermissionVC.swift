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
  private static let hasLocationPermissionKey = "hasLocationPermission"
  
  static var hasLocationPermission:Bool {
    get {
      let status = CLLocationManager.authorizationStatus()
      return status == .AuthorizedAlways || status == .AuthorizedWhenInUse
    }
  }
  
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
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    switch status {
    case .NotDetermined:
      break
    case .AuthorizedWhenInUse:
      //TODO: test to get rid of ambiguity... what to do?
      break
    case .AuthorizedAlways:
      gotPermission()
      break
    case .Restricted:
      break
    case .Denied:
      deniedPermission()
      break
    }
  }
  
}
