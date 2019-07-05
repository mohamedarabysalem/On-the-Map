//
//  MapViewController.swift
//  onTheMap
//
//  Created by Mohamad Elaraby on 3/29/19.
//  Copyright © 2019 Mohamad Elaraby. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController , MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let activityIndecator = UIActivityIndicatorView()
    var locations = StudentInformations.shared.data
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.activityIndicator(isProcessing: true)
        UdacityAPI.shared.getStudentLocations { (result,succ, error) in
            if error != nil {
                print("there was an error coulndnt fetch data")
            }
            
            if succ == false {
                print("there was an error ")
            }
            guard let results = result else {
                print("there was no data in this dictionary")
                return
            }
            
            self.locations = results
            for loc in self.locations {
                self.setAnnotaionOnTheMap(location: loc)
     
            }
            DispatchQueue.main.async {
                self.activityIndicator(isProcessing: false)
            }
        }

    }
    func setAnnotaionOnTheMap(location : StudentInformation){
        let annotation = MKPointAnnotation()
        let lat = location.latitude
        let lon = location.longitude
        annotation.coordinate = CLLocationCoordinate2DMake((lat) , (lon))
        let firstName = location.firstName
        let lastName = location.lastName
        annotation.title = firstName + lastName
        annotation.subtitle = location.mediaURL
        mapView.addAnnotation(annotation)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            guard let url = view.annotation?.subtitle! else{
                print("coulndt get url")
                return
            }
            openUrl(url: url)
            
        }
    }

    func openUrl(url:String){
        let url = URL(string: url)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    func activityIndicator (isProcessing : Bool){
        
        if isProcessing == true {
            activityIndecator.style = UIActivityIndicatorView.Style.gray
            activityIndecator.center = self.view.center
            activityIndecator.hidesWhenStopped = true
            activityIndecator.startAnimating()
            self.view.addSubview(activityIndecator)
            activityIndecator.startAnimating()
        }else {
            activityIndecator.stopAnimating()
        }
        
    }
    @IBAction func logoutButton(_ sender: Any) {
        UdacityAPI.shared.logout()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func refreshButton(_ sender: Any) {
        activityIndicator(isProcessing: true)
        UdacityAPI.shared.getStudentLocations { (result, succ, error) in
            if error != nil {
                print("there was an error coulndnt fetch data")
            }
            
            if succ == false {
                print("there was an error ")
            }
            guard let results = result else {
                print("there was no data in this dictionary")
                return
            }
            
            self.locations = results
            for loc in self.locations {
                self.setAnnotaionOnTheMap(location: loc)
            }
            DispatchQueue.main.async {
                self.activityIndicator(isProcessing: false)
            }
        }
        }
    
    @IBAction func addButton(_ sender: Any) {
       // checkUser()
        self.performSegue(withIdentifier: "addToParse", sender: self)
    }
    func checkUser(){
        activityIndicator(isProcessing: true)
        UdacityAPI.shared.getUserInformation { (firstName, lastName, key) in
            let firstName = firstName
            let lastName = lastName
            for location in self.locations{
                if firstName == location.firstName && lastName == location.lastName {
                    let alert = UIAlertController(title: "Attintion", message: "You Have Already Posted a Student Location. Would You like To Overwrite Your Current Location ", preferredStyle: .alert)
                    let overwriteAction = UIAlertAction(title: "Overwrite", style: .default, handler: { action in
                        self.performSegue(withIdentifier: "addToParse", sender: self)
                        self.activityIndicator(isProcessing: false)
                        })
                    let cancelAction = UIAlertAction(title: "Canel", style: .default, handler: nil)
                    alert.addAction(overwriteAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    
                    self.activityIndicator(isProcessing: false)
                }
            }
        }
    }
}
