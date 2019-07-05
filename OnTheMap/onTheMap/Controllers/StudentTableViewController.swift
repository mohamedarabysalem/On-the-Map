//
//  StudentTableViewController.swift
//  onTheMap
//
//  Created by Mohamad Elaraby on 4/1/19.
//  Copyright © 2019 Mohamad Elaraby. All rights reserved.
//

import UIKit

class StudentTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    let activityIndecator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UdacityAPI.shared.getStudentLocations { (results, succ, error) in
            if error != nil {
                print("there was an error coulndnt fetch data")
            }
            
            if succ == false {
                print("there was an empty dictionaries ")
            }
            guard let results = results else {
                print("there was no data in this dictionary")
                return
            }
            StudentInformations.shared.data = results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformations.shared.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell") as! StudentCell
        cell.imgView.image = UIImage(named: "icon_pin@3x.png")
        let firstName = StudentInformations.shared.data[indexPath.row].firstName
        let lastName = StudentInformations.shared.data[indexPath.row].lastName
        cell.titleLabel.text = firstName + " " + lastName
        cell.subtitleLabel.text = StudentInformations.shared.data[indexPath.row].mediaURL
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = StudentInformations.shared.data[indexPath.row].mediaURL
        openURL(url: url)
    }
    func openURL(url : String){
        let url = URL(string: url)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }

    @IBAction func logoutButton(_ sender: Any) {
        UdacityAPI.shared.logout()
        let vc = LoginViewController()
        vc.activityIndicator(isProcessing: false)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        activityIndicator(isProcessing: true)
        UdacityAPI.shared.getStudentLocations { (result, succ, error) in
            if error != nil {
                print("there was an error coulndnt fetch data")
            }
            
            if succ == false {
                print("there was an empty dictionaries ")
            }
            guard let results = result else {
                print("there was no data in this dictionary")
                return
            }
            
            StudentInformations.shared.data = results
            
           
            DispatchQueue.main.async {
                self.activityIndicator(isProcessing: false)
                    self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "addToParse", sender: self)
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
   

}
