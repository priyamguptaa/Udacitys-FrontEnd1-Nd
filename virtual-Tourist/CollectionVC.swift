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
import CoreLocation

class collectionVC: UIViewController {
    
  //  @IBOutlet weak var label: UILabel!
    @IBOutlet weak var newCollection: UIButton!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        
        //      We are adding the annotation to the map using the selectedPin(type is PIN)
        addAnnotationToMap(latitude: (selectedPin?.latitude)!,longitude: (selectedPin?.longitude)!)
        
        if selectedPin?.photo?.count == 0 {
            
            flickr.getDetailsFromFlickr(latitude: (selectedPin?.latitude)!, longitude: (selectedPin?.longitude)!) { (pages, numberOfImages) in
                
                if pages != nil {
                    print(pages!)
                    let randomPage = arc4random_uniform(UInt32(pages!)) + 1
                    flickr.getImageURLSFromFlickr(latitude: (selectedPin?.latitude)!, longitude: (selectedPin?.longitude)!, page: Int(randomPage))
                }
                
                if numberOfImages != nil {
                    print(numberOfImages!)
                    
                }
                DispatchQueue.main.async{
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let managedContext = appDelegate.persistentContainer.viewContext
                    do{
                        try managedContext.save()
                    }catch {
                        print("Error saving")
                    }
                }
            }
        }
        
        
        do {
            try self.fetchedResultsController.performFetch()
        }catch{
            print("An error occured")
        }
        
    }
    func randomPage() {
        
        let randomPageNumber = arc4random_uniform(UInt32(totalPages)) + 1
        
        flickr.getImageURLSFromFlickr(latitude: (selectedPin?.latitude)!, longitude: (selectedPin?.longitude)!, page: Int(randomPageNumber))
    }
    
    @IBAction func newImageCollection(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        while((selectedPin?.photo?.count)! > 0){
            
            let photo = fetchedResultsController.object(at: [0,0])
            managedContext.delete(photo)
            do{
                try managedContext.save()
            }catch {
                print("Error while saving")
            }
        }
        
    }
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    func addAnnotationToMap(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = latitude
        annotation.coordinate.longitude = longitude
        map.addAnnotation(annotation)
        
        let center = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpanMake(5, 5)
        let region = MKCoordinateRegion(center: center, span: span)
        map.setRegion(region, animated: true)
    }
    
    lazy var fetchedResultsController : NSFetchedResultsController = { () -> NSFetchedResultsController<Photo> in
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Photo>(entityName: "Photo")
        let sortDescriptor = NSSortDescriptor(key: "photoURL", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "pin = %@", argumentArray: [selectedPin!])
        let frc  = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    
}

extension collectionVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageFromFlickr", for: indexPath) as! collectionCellVC
        
        let activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
        
        activityIndicator.isHidden = false
        activityIndicator.center = CGPoint(x: cell.frame.width/2, y: cell.frame.height/2)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.layer.zPosition = 1
        cell.addSubview(activityIndicator)
        
        let photo = fetchedResultsController.object(at: indexPath)
        
        if photo.photoData == nil {
            activityIndicator.startAnimating()
            flickr.getImageDataFromURL(url: photo.url!, completionHandlerForImage: { (data) in
                DispatchQueue.main.async{
                    cell.imageView.image = UIImage(data: data)
                    activityIndicator.stopAnimating()
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let managedContext = appDelegate.persistentContainer.viewContext
                    photo.photoData = data as NSData as Data
                    
                    do{
                        try managedContext.save()
                    }catch{
                        print("Error saving")
                    }
                }
            })
        }
            
        else {
            cell.imageView.image = UIImage(data: photo.photoData! as Data)
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let photo = fetchedResultsController.object(at: indexPath)
        managedContext.delete(photo)
        
        do{
            try managedContext.save()
        }catch {
            print("Error while saving")
        }
    }
    
}

extension collectionVC : NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let insertIndexPath = newIndexPath{
                self.myCollectionView.insertItems(at: [insertIndexPath])
            }
        case .delete:
            if let deleteIndexpath = indexPath{
                self.myCollectionView.deleteItems(at: [deleteIndexpath])
            }
        case .move:
            if let deleteIndexPath = indexPath {
                self.myCollectionView.deleteItems(at: [deleteIndexPath])
            }
            if let insertIndexPath = newIndexPath {
                self.myCollectionView.insertItems(at: [insertIndexPath])
            }
        default:
            print()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            let sectionIndexSet = NSIndexSet(index: sectionIndex)
            self.myCollectionView.insertSections(sectionIndexSet as IndexSet)
        case .delete:
            let sectionIndexSet = NSIndexSet(index: sectionIndex)
            self.myCollectionView.deleteSections(sectionIndexSet as IndexSet)
        default:
            print("Nothing")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.myCollectionView.numberOfItems(inSection: 0)
    }
    
}







