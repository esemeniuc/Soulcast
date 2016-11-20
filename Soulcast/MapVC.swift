

import UIKit
import MapKit

protocol MapVCDelegate: class {
  func mapVCDidChangeradius(radius:Double)
}

class MapVC: UIViewController {
  
  let mapView = MKMapView()
  let locationManager = CLLocationManager()
  var permissionView: UIView!
  var latestLocation: CLLocation? {
    get {
      if let savedLatitude = Device.localDevice.latitude {
        if let savedLongitude = Device.localDevice.longitude {
          return CLLocation(latitude: savedLatitude, longitude: savedLongitude)
        }
      }
      return CLLocation(latitude: 49.2812277842772, longitude: -122.956074765067)
    }
    set (newValue) {
      let updatingDevice = Device.localDevice
      updatingDevice.latitude = newValue?.coordinate.latitude
      updatingDevice.longitude = newValue?.coordinate.longitude
      Device.localDevice = updatingDevice
    }
  }
  var userSpan: MKCoordinateSpan! {
    get {
      if let savedRadius = Device.localDevice.radius {
        
        return MKCoordinateSpanMake(savedRadius, savedRadius)
      } else {
        return MKCoordinateSpanMake(0.03, 0.03)
      }
    }
    set (newValue) {
      let updatingDevice = Device.localDevice
      updatingDevice.radius = newValue.latitudeDelta
      Device.localDevice = updatingDevice
    }
  }
  var originalRegion: MKCoordinateRegion?
  var devicesLabel =
    NumberOfDevicesLabel(frame:
      CGRect(x: 22, y: 22, width: 55, height: 55))
  var devicesLabelUpdating = false
  var devicesLabelUpdatedRecently = false
  weak var delegate: MapVCDelegate?
  
  var timer:NSTimer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addMap()
    addLabels()
    setupTimer()
  }
  
  func setupTimer() {
    timer = NSTimer(timeInterval: 35,
                    target: self,
                    selector: #selector(restartLocationUpdates(_:)),
                    userInfo: nil,
                    repeats: true)
    NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    timer?.fire()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    monitorLocation()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  
  func saveRegionData() {
    if let location = latestLocation {
      if let span = userSpan {
        deviceManager.updateDeviceRegion(location.coordinate.latitude as Double, longitude: location.coordinate.longitude as Double, radius: span.latitudeDelta as Double)
      }
    }
  }

  func addMap() {
    mapView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
    mapView.mapType = .Standard
    mapView.scrollEnabled = false
    mapView.rotateEnabled = false
    mapView.zoomEnabled = false
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
  
  func didPanOnMapView(pinchRecognizer:UIPinchGestureRecognizer) {
    switch pinchRecognizer.state {
    case .Began:
      originalRegion = mapView.region
    case .Changed:
      var latitudeDelta = Double(originalRegion!.span.latitudeDelta) / Double(pinchRecognizer.scale)
      var longitudeDelta = Double(originalRegion!.span.longitudeDelta) / Double(pinchRecognizer.scale);
      latitudeDelta = max(min(latitudeDelta, 10), 0.0005);
      longitudeDelta = max(min(longitudeDelta, 10), 0.0005);
      userSpan = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
      updateDevicesLabel()
      self.mapView.setRegion(MKCoordinateRegionMake(originalRegion!.center, userSpan!), animated: false)
      self.delegate?.mapVCDidChangeradius(userSpan.latitudeDelta)
    case .Ended:
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
    return CLLocationManager.authorizationStatus() == .AuthorizedAlways || CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse
  }
  
  
  static func systemAskLocationPermission(locationManager: CLLocationManager) {
    /*
     Must include in .plist
     <key>NSLocationAlwaysUsageDescription</key>
     <string>Optional message</string>
     */
    if locationManager.respondsToSelector(#selector(CLLocationManager.requestAlwaysAuthorization)) {
      locationManager.requestAlwaysAuthorization()
    }
    if locationManager.respondsToSelector(#selector(CLLocationManager.requestWhenInUseAuthorization)) {
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
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.75 * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {
      self.devicesLabelUpdatedRecently = false
    }
    
    
    devicesLabelUpdating = true
    devicesLabelUpdatedRecently = true
    if Device.localDevice.radius != nil {
      deviceManager.getNearbyDevices({
        (response:[String : AnyObject]) in
        self.devicesLabelUpdating = false
        if let nearby = response["nearby"] {
          let oldText = self.devicesLabel.text
          let newText = String(nearby)
          if oldText != newText {
            self.devicesLabel.text = newText
            self.devicesLabel.wiggle()
          }
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
    UIView.animateWithDuration(0.37) { 
      radiusExplainerView.alpha = 1
    }
  }
  
}

extension MapVC: MKMapViewDelegate {
  func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
    let mapRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: userSpan!)
    mapView.setRegion(mapRegion, animated: true)
    
  }
  
  func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    
  }
  
  func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    //
  }
}

extension MapVC: CLLocationManagerDelegate {
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    updateIfMoved(manager, location: locations.last)
    updateDevicesLabel()
  }
    
  func updateIfMoved(manager: CLLocationManager, location: CLLocation!) {
    if let previousLocation = latestLocation {
      let distance = location.distanceFromLocation(previousLocation)
      if distance > 50 {
        //moved a lot
      }
    }
    manager.stopUpdatingLocation()
    latestLocation = location
  }
  
  func restartLocationUpdates(timer: NSTimer) {
    locationManager.startUpdatingLocation()
    saveRegionData()
  }
  
  
}

