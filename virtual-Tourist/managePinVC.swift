//
//  managePinVC.swift
//  virtual-Tourist
//
//  Created by Priyam Gupta on 02/04/18.
//  Copyright © 2018 Priyam. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class managePinVC: UIViewController, MKMapViewDelegate{
    
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var mapOutlet: MKMapView!
    
    class func sharedInstance() -> managePinVC {
        struct Singleton {
            static var sharedInstance = managePinVC()
        }
        return Singleton.sharedInstance
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBAction func editAction(_ sender: Any) {
        editButton.isHidden = true
        doneButton.isHidden = false
    }
    
    @IBAction func doneAction(_ sender: Any) {
        editButton.isHidden = false
        doneButton.isHidden = true
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        doneButton.isHidden = true
        pinGesture()
        fetchPins()
    }
    var allPins = [Pin]()
}

    extension managePinVC : UIGestureRecognizerDelegate{
        
    func pinGesture(){
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(location(gestureRecognizer: )))
        gesture.minimumPressDuration = 1.0
        mapOutlet.addGestureRecognizer(gesture)
        
    }
        
    @objc func location (gestureRecognizer: UILongPressGestureRecognizer){
        if editButton.isHidden == false{
            if gestureRecognizer.state == .began{
                let coordinates = mapOutlet.convert(gestureRecognizer.location(in: mapOutlet), toCoordinateFrom: mapOutlet)
               // saveDataToCore(latitude)
                saveDataToCore(lat: coordinates.latitude, long: coordinates.longitude)
                placePin(lat: coordinates.latitude, long: coordinates.longitude)
            }
        }
    }
        
    func saveDataToCore(lat: CLLocationDegrees,long: CLLocationDegrees){
            
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Pin",in: context)!
        let pin = NSManagedObject(entity: entity, insertInto: context)
        pin.setValue(lat, forKey: "latitude")
        pin.setValue(long, forKey: "longitude")
            do{
                try context.save()
            }
            catch{
                print(Constants.errors.saveError)
            }
        }
        
        func deletePins(lat: CLLocationDegrees,long: CLLocationDegrees){
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Pin>(entityName: "Pin")
            do{
                let pins = try context.fetch(fetchRequest)
                for pin in pins{
                    if pin.latitude == lat && pin.longitude == long{
                        context.delete(pin)
                    }
                }
            }
            catch{
                print(Constants.errors.deleteError)
            }
            do{
                try context.save()
            }
            catch{
                print(Constants.errors.deleteError)
            }
        }
        
    func placePin(lat: CLLocationDegrees,long: CLLocationDegrees){
            
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = lat
            annotation.coordinate.longitude = long
            mapOutlet.addAnnotation(annotation)
    }
        
    func display(mapView: MKMapView, didSelect view: MKAnnotationView) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Pin>(entityName : "Pin")
            do{
         
                let pins = try managedContext.fetch(fetchRequest)
                for pin in pins {
                    if pin.latitude == view.annotation?.coordinate.latitude && pin.longitude == view.annotation?.coordinate.longitude {
                        selectedPin = pin
                    }
                }
            }
            catch
            {
                print(Constants.errors.fetchError)
            }
 
            if editButton.isEnabled == true {
                performSegue(withIdentifier: "collectionVC", sender: self)
            }
            if editButton.isEnabled == false {
                mapView.removeAnnotation(view.annotation!)
                deletePins(lat: (selectedPin?.latitude)!, long: (selectedPin?.longitude)!)
            }
        }

        func fetchPins(){
            
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Pin>(entityName: "Pin")
            do{
                allPins = try context.fetch(fetchRequest)
            }
            catch{
                print(Constants.errors.fetchError)
            }
            for pin in allPins{
                placePin(lat: pin.latitude, long: pin.longitude)
            }
        }
}
