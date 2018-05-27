//
//  dataController.swift
//  virtual-Tourist
//
//  Created by Priyam Gupta on 02/04/18.
//  Copyright © 2018 Priyam. All rights reserved.
//

/*import Foundation
import CoreData

class dataController {
    let persistentContainer:NSPersistentContainer
    
    var viewContext: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    init(modelName: String){
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    func load(completion: (() -> Void)? = nil){
        persistentContainer.loadPersistentStores{ storeDescription, error in
            guard error == nil else{
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
} */

/*
 //
 //  collectionVC.swift
 //  virtual-Tourist
 //
 //  Created by Priyam Gupta on 02/04/18.
 //  Copyright © 2018 Priyam. All rights reserved.
 //
 
 import UIKit
 import MapKit
 import CoreData
 import CoreLocation
 
 class collectionVC: UIViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
 
 @IBOutlet weak var mapOutlet: MKMapView!
 @IBOutlet weak var collectionView: UICollectionView!
 @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 // Setting up a collection flow layout
 let space:CGFloat = 3.0
 let dimension = (view.frame.size.width - (2 * space)) / 3.0
 flowLayout.minimumInteritemSpacing = space
 flowLayout.minimumLineSpacing = space
 flowLayout.itemSize = CGSize(width: dimension, height: dimension)
 addAnnotation(lat: (selectedPin?.latitude)!, long: (selectedPin?.longitude)!)
 
 
 }
 
 func addAnnotation(lat: CLLocationDegrees,long: CLLocationDegrees){
 
 // managePinVC.sharedInstance().placePin(lat: lat, long: long)
 let annotation = MKPointAnnotation()
 annotation.coordinate.latitude = lat
 annotation.coordinate.longitude = long
 mapOutlet.addAnnotation(annotation)
 
 let location = CLLocationCoordinate2D(latitude: lat,longitude: long)
 let span = MKCoordinateSpanMake(5, 5)
 let region = MKCoordinateRegion(center: location, span: span)
 mapOutlet.setRegion(region, animated: true)
 
 }
 
 @IBAction func newImageCollection(_ sender: Any) {
 
 }
 
 func randomPage(){
 
 }
 
 
 func numberOfSections(in collectionView: UICollectionView) -> Int {
 
 }
 
 
 func startAnimation(activityIndicator: UIActivityIndicatorView){
 activityIndicator.startAnimating()
 }
 func stopAnimation(activityIndicator: UIActivityIndicatorView){
 activityIndicator.stopAnimating()
 }
 
 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageFromflickrr", for: indexPath) as! collectionCellVC
 let activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
 activityIndicator.isHidden = false
 activityIndicator.center = CGPoint(x: cell.frame.width/2, y: cell.frame.height/2)
 
 activityIndicator.hidesWhenStopped = true
 activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
 cell.addSubview(activityIndicator)
 
 //handleActivityIndicator(cell: cell)
 let image = fetchResultsController.object(at: indexPath)
 if image.photoData == nil{
 startAnimation(activityIndicator: activityIndicator)
 }
 
 }
 
 
 func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
 
 let appDelegate = UIApplication.shared.delegate as! AppDelegate
 let context = appDelegate.persistentContainer.viewContext
 let image = fetchResultsController.object(at: indexPath)
 context.delete(image)
 do{
 try context.save()
 }
 catch{
 print(Constants.errors.saveError)
 }
 }
 
 lazy var fetchResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Photo> in
 let appDelegate = UIApplication.shared.delegate as! AppDelegate
 let context = appDelegate.persistentContainer.viewContext
 let fetchRequest = NSFetchRequest<Photo>(entityName: "Photo")
 let fetchedResults = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
 // fetchedResults.delegate = self;
 return fetchedResults
 
 }()
 
 
 
 
 }
 
*/
