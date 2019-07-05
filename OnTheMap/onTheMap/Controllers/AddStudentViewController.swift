//
//  AddStudentViewController.swift
//  onTheMap
//
//  Created by Mohamad Elaraby on 4/5/19.
//  Copyright © 2019 Mohamad Elaraby. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddStudentViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    var latitude : Double?
    var longitude : Double?
    let activityIndecator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func findLocationButton(_ sender: Any) {
        if locationTextField.text == "" || websiteTextField.text == "" {
            let alert = UIAlertController(title: "Error", message: "Location and URL are required", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else {
            let validURL = verifyUrl(urlString: websiteTextField.text)
            if validURL{
            self.activityIndicator(isProcessing: true)
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = locationTextField.text
            let activeSearch = MKLocalSearch(request: searchRequest)
            
            activeSearch.start { (response, error) in
                
                UIApplication.shared.endIgnoringInteractionEvents()
                
                if response == nil {
                    let alert = UIAlertController(title: "Location is unobtained", message: "There were an error while searching fot the location", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    self.activityIndicator(isProcessing: false)
                }else {
                    self.latitude = response?.boundingRegion.center.latitude
                    self.longitude = response?.boundingRegion.center.longitude
                    self.activityIndicator(isProcessing: false)
                    self.performSegue(withIdentifier: "goToMap", sender: self)
                    
                }
            }}
            
        }
    }
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMap"{
            let vc = segue.destination as! FindLocationViewController
            vc.searchedLocation = locationTextField.text
            vc.website = websiteTextField.text
            vc.latitude = latitude
            vc.longitude = longitude
            
        }
    }
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        let urlString = urlString!
            // create NSURL instance
            let url = NSURL(string: urlString)
        // check if your application can open the NSURL instance
        if UIApplication.shared.canOpenURL(url as! URL) {
                    return true
                }else {
            let alert = UIAlertController(title: "Error", message: "Pleas enter a valid URL", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return false
                }
    }
}
