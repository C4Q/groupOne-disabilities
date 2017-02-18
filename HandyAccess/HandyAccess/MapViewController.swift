//
//  MapViewController.swift
//  HandyAccess
//
//  Created by Karen Fuentes on 2/17/17.
//  Copyright © 2017 NYCHandyAccess. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate/*UICollectionViewDelegate, UICollectionViewDataSource*/ {
    
    var annotations = [MGLAnnotation]()
    let locationManager: CLLocationManager = {
        let locMan: CLLocationManager = CLLocationManager()
        locMan.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locMan.distanceFilter = 50.0
        return locMan
    }()
    let geocoder: CLGeocoder = CLGeocoder()
    var userLatitude = Float()/* = 40.776104*/
    var userLongitude = Float() /*= -73.920822*/
    let cellIdentifier = "ButtonCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewHierarchy()
        setupView()
        
        locationManager.delegate = self
        mapView.delegate = self
        
//        let initialLocation = CLLocation(latitude: CLLocationDegrees(userLatitude), longitude: CLLocationDegrees(userLongitude))
//        centerMapOnLocation(initialLocation)
        
        showModal()
    }
    
    func showModal() {
        let modalViewController = ButtonViewController()
        modalViewController.modalPresentationStyle = .overCurrentContext
        present(modalViewController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Authorized")
            manager.stopUpdatingLocation()
        case .denied, .restricted:
            print("Authorization denied or restricted")
        case .notDetermined:
            print("Authorization undetermined")
            locationManager.requestAlwaysAuthorization()
        }
    }
    
//    func centerMapOnLocation(_ location: CLLocation) {
//        let coordinateRegion = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        mapView.setCenter(coordinateRegion, zoomLevel: 13, animated: true)
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let validLocation: CLLocation = locations.last else { return }
        let locationValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
        userLatitude =  Float(locationValue.latitude)
        userLongitude = Float(locationValue.longitude)
        
        mapView.setCenter(locationValue, animated: true)

        geocoder.reverseGeocodeLocation(validLocation) { (placemarks: [CLPlacemark]?, error: Error?) in
            //error handling
            if error != nil {
                dump(error!)
            }
            
            guard let validPlaceMarks: [CLPlacemark] = placemarks,
                let validPlace: CLPlacemark = validPlaceMarks.last else { return }
            print(validPlace)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error encountered")
        dump(error)
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        let newlogitude = center.longitude
        let newlatitude = center.latitude
        print("log = \(newlogitude), lat = \(newlatitude)")
//        userLongitude = Float(newlogitude)
//        userLatitude = Float(newlatitude)
    }
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ButtonCollectionViewCell
//        
//        cell.filterButton.backgroundColor = UIColor.brown
//        cell.filterButton.titleLabel?.text = "button"
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        return CGSize(width: view.frame.width/5, height: 150)
//    }
    
    
    func setupViewHierarchy() {
        self.edgesForExtendedLayout = []
        
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
//        mapView.addSubview(buttonCategoriesCollectionView)
    }

    func setupView() {
//        buttonCategoriesCollectionView.snp.makeConstraints({ (view) in
//            view.bottom.equalToSuperview().inset(20)
//            view.width.equalToSuperview().multipliedBy(0.8)
//            view.height.equalTo(150)
//            view.centerX.equalToSuperview()
//        })
//        buttonCategoriesCollectionView.delegate = self
//        buttonCategoriesCollectionView.dataSource = self
//        buttonCategoriesCollectionView.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }

    internal var mapView: MGLMapView = {
        let mapView = MGLMapView()
        return mapView
    }()
    
//    internal lazy var buttonCategoriesCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = UIColor.black
//        return collectionView
//    }()

}
