//
//  HomeVC.swift
//  LocationFetch
//
//  Created by differenz189 on 18/02/22.
//

import UIKit
import CoreData
import CoreLocation

let appDelegate = UIApplication.shared.delegate as! AppDelegate
class HomeVC: UIViewController {
    
    
    @IBOutlet weak var txtLatitude: UILabel!
    @IBOutlet weak var txtLongitude: UILabel!
    
    private let managedContext = appDelegate.persistentContainer.viewContext
    private var data: [NSManagedObject] = []
    private var locationManager: CLLocationManager?
   
    
    private var lastUpdatedTime: Date = Date()
    private var updateInteraval: Int = 0
    private var longi: String = ""
    private var lati: String = ""
    
    
    //    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        
        saveToCoreData(latitude: lati, longitude: longi)
        
        //MARK: - To notify app Presentation mode
        //        let notificationCenter = NotificationCenter.default
        //        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        //
        //        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        self.txtLatitude.text = "Latitude :- \t" + self.lati
        self.txtLongitude.text = "Longitude :- \t" + self.longi
    }
    
    
    @objc func appMovedToBackground() {
        // if want to
    }
    
    @objc func appCameToForeground() {
        // if want to stop fecthing location in
    }
    
    private func saveToCoreData(latitude: String, longitude: String) {
        let entity = NSEntityDescription.entity(forEntityName: "LocationEntity", in : managedContext)!
        let record = NSManagedObject(entity: entity, insertInto: managedContext)
        
        record.setValue(latitude, forKey: "latitude")
        record.setValue(longitude, forKey: "longitude")
        
        do {
            try managedContext.save()
            print("Location Updated")
        } catch {
            print("Error")
        }
    }
    
    func isTimeToUpdateLocation(now:Date) -> Bool {
        
            let timePast = now.timeIntervalSince(lastUpdatedTime)
            let intervalExceeded = Int(timePast) > updateInteraval

            print("timePast",timePast)
            print("interval",intervalExceeded)
        
            return intervalExceeded
        }
}

extension HomeVC: CLLocationManagerDelegate {
 
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            print("LocationManager didChangeAuthorization notDetermined")
            return
        case .restricted:
            return
        case .denied:
            print("LocationManager didChangeAuthorization denied")
            return
        case .authorizedAlways:
            print("LocationManager didChangeAuthorization authorizedAlways")
            locationManager?.requestLocation()
            return
        case .authorizedWhenInUse:
            print("LocationManager didChangeAuthorization authorizedWhenInUse")
            locationManager?.requestLocation()
            return
        case .authorized:
            print("LocationManager didChangeAuthorization authorized")
            locationManager?.requestLocation()
            return
        default:
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last?.coordinate
        
        self.longi = String(currentLocation?.longitude ?? 0)
        self.lati = String(currentLocation?.latitude ?? 0)
        
        if isTimeToUpdateLocation(now: Date()) {
            saveToCoreData(latitude: String(currentLocation?.latitude ?? 0), longitude: String(currentLocation?.longitude ?? 0))
        }
        self.viewWillLayoutSubviews()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            locationManager?.stopMonitoringSignificantLocationChanges()
            return
        }
    }
}
