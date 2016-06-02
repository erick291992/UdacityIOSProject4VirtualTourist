//
//  MapViewController.swift
//  virtualTourist
//
//  Created by Erick Manrique on 5/28/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    var selectedPin:Pin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        NetworkClient.sharedInstance().searchByLatLon("37",longitude: "-119") { (success, error) in
//            print("worked ")
//        }
        do {
            try fetchedResultsController.performFetch()
        } catch {}
        
        fetchedResultsController.delegate = self
        addStoredAnnotations()
        
        var uilpgr = UILongPressGestureRecognizer(target: self, action: Selector("action:"))
        uilpgr.minimumPressDuration = 2
        mapView.addGestureRecognizer(uilpgr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem?.title = "Edit"
    }

    //CoreData
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: self.sharedContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        
        return fetchedResultsController
        
    }()

    // MARK: - Action
    @IBAction func EditPressed(sender: AnyObject) {
        editDonePressed()
    }
    
    // MARK: - Map View delegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = UIColor.redColor()
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if control == view.rightCalloutAccessoryView {
//            let app = UIApplication.sharedApplication()
//            if let toOpen = view.annotation?.subtitle! {
//                app.openURL(NSURL(string: toOpen)!)
//            }
//        }
        print("map pressed")
    }
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("annotation pressed")
        let a = mapView.selectedAnnotations[0] as! Pin
        print(a.latitude)
        self.mapView.deselectAnnotation(view.annotation!, animated: true)
        
//        let chosenPin = view.annotation! as! Pin
//        let pinAnnotationView = view as! MKPinAnnotationView
//        let chosenPin = pinAnnotationView.annotation as! Pin
        let annotation = view.annotation
        let pin = searchForPin(annotation!)
        newVC(pin)
    }
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        print("deselected")
    }
    
    func newVC(pin:Pin?){
        
        let detailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoAlbumViewController") as! PhotoAlbumViewController
        print(pin)
        if let myPin = pin{
            print("casted pin")
            detailViewController.pin = myPin
        }
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func searchForPin(annotation: MKAnnotation) -> Pin?{
        if let pins = fetchedResultsController.fetchedObjects as? [Pin]{
            for pin in pins{
                if annotation.coordinate.latitude == pin.latitude && annotation.coordinate.longitude == pin.longitude{
                    return pin
                }
            }
        }
        return nil
    }
    
    // MARK: - gesture Action method
    func action(gestureRecognizer: UIGestureRecognizer){
        switch gestureRecognizer.state {
        case .Began:
            let touchPoint = gestureRecognizer.locationInView(self.mapView)
            let newCoordinate: CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinate
            mapView.addAnnotation(annotation)
//            _ = Pin(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude, context: sharedContext)
            let pinToSave = Pin(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude, context: sharedContext)
            
            CoreDataStackManager.sharedInstance().saveContext()
        default:
            return
        }
        
    }
    
    //methods
    func addStoredAnnotations(){
        if let pins = fetchedResultsController.fetchedObjects as? [Pin]{
            for pin in pins{
                let lat = pin.latitude as Double
                let long = pin.longitude as Double
                let newCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let annotation = MKPointAnnotation()
                annotation.coordinate = newCoordinate
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    //http://stackoverflow.com/questions/29248203/animate-uiview-height-when-using-auto-layout-with-swift
    func editDonePressed(){
        let title = self.navigationItem.rightBarButtonItem?.title

        if title == "Edit"{
            self.navigationItem.rightBarButtonItem?.title = "Done"
            UIView.animateWithDuration(0.5) {
                self.bottomViewHeight.constant = 100
                self.view.layoutIfNeeded()
            }
        }
        else{
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            UIView.animateWithDuration(0.5) {
                self.bottomViewHeight.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }

}

