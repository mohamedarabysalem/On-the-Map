//
//  FindLocationViewController.swift
//  onTheMap
//
//  Created by Mohamad Elaraby on 4/5/19.
//  Copyright © 2019 Mohamad Elaraby. All rights reserved.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var latitude : Double?
    var longitude : Double?
    var firstName : String?
    var lastName : String?
    var searchedLocation: String?
    var website : String?
    var key : String?
    var student : StudentInformation?
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
       // UdacityAPI.shared.getUserInformation()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion.init(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        DispatchQueue.main.async {
            UdacityAPI.shared.getUserInformation { (firstName, lastName,key) in
                self.firstName = firstName
                self.lastName = lastName
                self.key = key
                self.setStudentInformation()
                
            }
        }
    }
    func setStudentInformation(){
        
        
        let information = ["firstName" : firstName,
                           "lastName" : lastName,
                           "latitude" : latitude,
                           "longitude" : longitude,
                           "mediaURL":website,
                           "mapString":searchedLocation,
                           "uniqueKey":key] as! NSDictionary
        
        student = StudentInformation(res: information)
        print(student)
        
    }
    
    @IBAction func submitButton(_ sender: Any) {
        UdacityAPI.shared.postStudentLocation(studentInformation: student!) { (succ, error) in
            if succ == true {
                print("posted succssfully")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }
    }
}
