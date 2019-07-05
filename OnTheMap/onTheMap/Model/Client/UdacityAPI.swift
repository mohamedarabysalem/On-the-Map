//
//  UdacityAPI.swift
//  onTheMap
//
//  Created by Mohamad Elaraby on 3/29/19.
//  Copyright © 2019 Mohamad Elaraby. All rights reserved.
//

import Foundation
import UIKit

class UdacityAPI : NSObject{
    static let shared = UdacityAPI()
    let sharedSession = URLSession.shared
    var accountKey : String?
    var studentLocations = [StudentInformation]()
    let vc = LoginViewController()
    
    
    
    func login(email: String, password: String, completion: @escaping (_ succ: Bool, _ error: String?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        //var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let task = sharedSession.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
                completion(false,error!.localizedDescription)
            }
            
            //get http response
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Expected HTTPURLResponse but was \(type(of: response))")
                completion(false,"Expected HTTPURLResponse but was \(type(of: response))")
                return
            }
            
            //check http response status code was 2xx
            guard httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299 else {
                print("There was a problem with the request. Status code is \(httpResponse.statusCode)")
                completion(false,"There was a problem with the request. Status code is \(httpResponse.statusCode)")
                return
            }
            
            //check data was returned
            if data == nil {
                print("No data was returned in the response.")
                completion(false,"No data was returned in the response.")
            }
            /* subset response data! */
            let range = Range(5..<data!.count)
            let newData = data!.subdata(in: range)
            let parsedData : NSDictionary
            let account : [String : AnyObject]
            //let session : [String : AnyObject]
            do {
                parsedData = try! JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! NSDictionary
                account = parsedData["account"] as! [String : AnyObject]
                guard let session = parsedData["session"] as? [String : AnyObject] else{
                    completion(false, "Login Failed, no session to the user credentials provided.")
                    return}
                completion(true,nil)
            }catch let error {
                print(error)
                completion(false,nil)
            }
                
                        print(parsedData)
            self.accountKey = account["key"] as! String
            print(self.accountKey)
            
        }
        task.resume()
    }
    
    func getStudentLocations(completion: @escaping (_ results : [StudentInformation]?,_ succ : Bool , _ error : String?) -> Void){
        let limit = 100
        let skip = 0
        let orderBy = "createdAt"
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation?order=-\(orderBy)&limit=\(limit)&skip=\(skip)"
        let url = URL(string: urlString)
        print(url)
        var request = URLRequest(url: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = sharedSession.dataTask(with: request) { (data, response, error) in
            if self.errorHandler(error: error, response: response, data: data){
                completion(nil,false,error as! String)
            }else{
            let parsedData : NSDictionary
            do{
                parsedData = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
            }  catch let error {
                completion(nil,false,"There is an error decoding data")
                print(error.localizedDescription)
                return
            }
            
            guard let results = parsedData["results"] as? [NSDictionary] else {
                print("there is an error fetching Data")
                return
            }
            for result in results {
                print(result)
                self.studentLocations.append(StudentInformation(res : result))
            }
            completion(self.studentLocations, false, nil)
          }
        }
        task.resume()
    }
    func logout(){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            self.errorHandler(error: error, response: response, data: data)
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            let parsedData : NSDictionary
            do {
                parsedData = try! JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! NSDictionary
            }catch{
                print("coulnt fetch data")
            }
            let session = parsedData["session"] as! [String:AnyObject]
            print(session)
        }
        task.resume()
    }
    func getUserInformation (complition : @escaping (_ firsName :String?,_ lastName : String?,_ key : String?)-> Void){
            var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(accountKey!)")!)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if self.errorHandler(error: error, response: response, data: data) {
                    complition(nil,nil,nil)
                }else{
                let range = Range(5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */
                let parsedData: NSDictionary
                do {
                    parsedData = try! JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! NSDictionary
                    print(parsedData)
                }catch let error {

                }
                let firstName = parsedData["first_name"] as! String
                let lastName = parsedData["last_name"] as! String
                    complition(firstName,lastName,self.accountKey)
                    
                }
            }
        
            task.resume()
    }
    func postStudentLocation(studentInformation:StudentInformation,completion:@escaping(Bool,Error?)->Void){
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(studentInformation.uniqueKey)\", \"firstName\": \"\(studentInformation.firstName)\", \"lastName\": \"\(studentInformation.lastName)\",\"mapString\": \"\(studentInformation.mapString)\", \"mediaURL\": \"\(studentInformation.mediaURL)\",\"latitude\": \(studentInformation.latitude), \"longitude\": \(studentInformation.longitude)}".data(using: .utf8)

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if self.errorHandler(error: error, response: response, data: data){
            }else{
                print(String(data: data!, encoding: .utf8)!)}
            completion(true,nil)
        }
        task.resume()
        
    }
    func errorHandler(error : Error?,response:URLResponse?,data:Data?) -> Bool{
            
            //check no error was returned
            if error != nil {
                print(error!.localizedDescription)
                return true
            }
            
            //get http response
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Expected HTTPURLResponse but was \(type(of: response))")
                return true
            }
            
            //check http response status code was 2xx
            guard httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299 else {
               print("There was a problem with the request. Status code is \(httpResponse.statusCode)")
                
                return true
            }
            
            //check data was returned
            if data == nil {
                 print("No data was returned in the response.")
                return true
            }
//        do {
//           let parsedData = try! JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! NSDictionary
//            let account = parsedData["account"] as! [String : AnyObject]
//            guard let session = parsedData["session"] as? [String : AnyObject] else{
//               // completion(false, "Login Failed, no session to the user credentials provided.")
//                return }
//           // completion(true,nil)
//        }catch let error {
//            print(error)
//            //completion(false,nil)
//        }
            return false
        
        
    }
}
