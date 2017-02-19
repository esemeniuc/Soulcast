

import UIKit
import MapKit

protocol MapVCDelegate: class {
  func mapVCDidChangeradius(_ radius:Double)
}

class MapVC: UIViewController {
  
  let mapView = MKMapView()
  let locationManager = CLLocationManager()
  var permissionView: UIView!
  var latestLocation: CLLocation? {
    get {
      if let savedLatitude = Device.latitude,
        let savedLongitude = Device.longitude {
        return CLLocation(latitude: savedLatitude, longitude: savedLongitude)
      } else {
        return CLLocation(latitude: 49.2812277842772, longitude: -122.956074765067)
      }
    }
    set (newValue) {
      Device.latitude = newValue?.coordinate.latitude
      Device.longitude = newValue?.coordinate.longitude
    }
  }
  var userSpan: MKCoordinateSpan! {
    get {
      if let savedRadius = Device.radius {
        return MKCoordinateSpanMake(savedRadius, savedRadius)
      } else {
        return MKCoordinateSpanMake(0.03, 0.03)
      }
    }
    set (newValue) {
      Device.radius = newValue.longitudeDelta
    }
  }
  var originalRegion: MKCoordinateRegion?
  var devicesLabel =
    NumberOfDevicesLabel(frame:
      CGRect(x: 22, y: 22, width: 55, height: 55))
  var devicesLabelUpdating = false
  var devicesLabelUpdatedRecently = false
  weak var delegate: MapVCDelegate?
  
  var timer:Timer?
  
  let tiltCamera = MKMapCamera()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
    addMap()
    addLabels()
    setupTimer()
    setupTiltCamera()
  }
  
  func setupTiltCamera() {
    tiltCamera.centerCoordinate = mapView.centerCoordinate
    tiltCamera.pitch = 80.0
    tiltCamera.altitude = 100.0
    tiltCamera.heading = 0
  }
  
  func setupTimer() {
    timer = Timer(timeInterval: 35,
                    target: self,
                    selector: #selector(restartLocationUpdates(_:)),
                    userInfo: nil,
                    repeats: true)
    RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    timer?.fire()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    monitorLocation()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

  }
  
  func saveRegionData() {
    if let location = latestLocation {
      if let span = userSpan {
        Device.updateDeviceRegion(
          location.coordinate.latitude as Double,
          longitude: location.coordinate.longitude as Double,
          radius: span.longitudeDelta as Double)
      }
    }
  }

  func addMap() {
    mapView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
    mapView.mapType = .standard
    mapView.isScrollEnabled = false
    mapView.isRotateEnabled = false
    mapView.isZoomEnabled = false
    mapView.showsUserLocation = true
    if let location = latestLocation {
      if let span = userSpan {
        
        mapView.setRegion(MKCoordinateRegionMake(location.coordinate, span), animated: true)
        
      }
    }
    mapView.delegate = self
    view.addSubview(mapView)
    
    addPinchGestureRecognizer()
  }
  
  func addPinchGestureRecognizer() {
    let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(MapVC.didPanOnMapView(_:)))
    mapView.addGestureRecognizer(pinchRecognizer)
  }
  
  func didPanOnMapView(_ pinchRecognizer:UIPinchGestureRecognizer) {
    switch pinchRecognizer.state {
    case .began:
      originalRegion = mapView.region
    case .changed:
      var latitudeDelta = Double(originalRegion!.span.latitudeDelta) / Double(pinchRecognizer.scale)
      var longitudeDelta = Double(originalRegion!.span.longitudeDelta) / Double(pinchRecognizer.scale);
      latitudeDelta = max(min(latitudeDelta, 10), 0.0005);
      longitudeDelta = max(min(longitudeDelta, 10), 0.0005);
      userSpan = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
      updateDevicesLabel()
      self.mapView.setRegion(MKCoordinateRegionMake(originalRegion!.center, userSpan!), animated: false)
      self.delegate?.mapVCDidChangeradius(userSpan.latitudeDelta)
    case .ended:
      saveRegionData()
      
      break
    default:
    break
    }
    
  }
  
  func monitorLocation() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.distanceFilter = 10
    locationManager.startUpdatingLocation()
  }
  
  static func hasLocationPermission() -> Bool {
    return CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse
  }
  
  
  static func systemAskLocationPermission(_ locationManager: CLLocationManager) {
    /*
     Must include in .plist
     <key>NSLocationAlwaysUsageDescription</key>
     <string>Optional message</string>
     */
    if locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)) {
      locationManager.requestAlwaysAuthorization()
    }
    if locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
      locationManager.requestWhenInUseAuthorization()
    }
  }
  
  func addLabels() {
    let devicesLabelTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(devicesLabelTapped))
    devicesLabel.addGestureRecognizer(devicesLabelTapRecognizer)
    view.addSubview(devicesLabel)
    
    updateDevicesLabel()
  }
  
  func updateDevicesLabel() {
    if devicesLabelUpdating || devicesLabelUpdatedRecently{
      return
    }
    let delayTime = DispatchTime.now() + Double(Int64(0.75 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
      self.devicesLabelUpdatedRecently = false
    }
    
    
    devicesLabelUpdating = true
    devicesLabelUpdatedRecently = true
    if Device.radius != nil {
      ServerFacade.getNearbyDevices({
        nearbyCount in
        self.devicesLabelUpdating = false
        
        let oldText = self.devicesLabel.text
        let newText = String(describing: nearbyCount)
        if oldText != newText {
          self.devicesLabel.text = newText
          self.devicesLabel.wiggle()
        }
        
      }) {
        self.devicesLabelUpdating = false
        self.devicesLabel.text = "0"
      }

    }
  }
  
  func devicesLabelTapped() {
    presentRadiusExplainer()
  }
  
  func presentRadiusExplainer() {
    let radiusExplainerView = RadiusExplainerView(maskCircleArea: devicesLabel.frame)
    radiusExplainerView.alpha = 0
    view.superview?.addSubview(radiusExplainerView)
    UIView.animate(withDuration: 0.37, animations: { 
      radiusExplainerView.alpha = 1
    }) 
  }
  
  
}

extension MapVC: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    let mapRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: userSpan!)
    mapView.setRegion(mapRegion, animated: true)
  }
  
  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    
  }
  
  func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    //
  }
}

extension MapVC: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    updateIfMoved(manager, location: locations.last)
    updateDevicesLabel()
  }
    
  func updateIfMoved(_ manager: CLLocationManager, location: CLLocation!) {
    if let previousLocation = latestLocation {
      let distance = location.distance(from: previousLocation)
      if distance > 50 {
        //moved a lot
      }
    }
    manager.stopUpdatingLocation()
    latestLocation = location
  }
  
  func restartLocationUpdates(_ timer: Timer) {
    locationManager.startUpdatingLocation()
    saveRegionData()
  }
  
  
}

