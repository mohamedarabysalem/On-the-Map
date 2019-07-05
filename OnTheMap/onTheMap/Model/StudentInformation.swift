//
//  studentRecord.swift
//  onTheMap
//
//  Created by Mohamad Elaraby on 3/23/19.
//  Copyright © 2019 Mohamad Elaraby. All rights reserved.
//

import Foundation

struct StudentInformation : Codable {
    var createdAt: String
    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    var objectId: String
    var uniqueKey: String
    var updatedAt: String
    
    init(res: NSDictionary) {

        if let n = res["createdAt"] as? String  {
            createdAt = n
        }else{
            createdAt = ""
            print("there is no createdAt key")
        }
        if let n = res["firstName"] as? String  {
            firstName = n
        }else{
            firstName = ""
            print("there is no firstName key")
        }
        if let n = res["lastName"] as? String  {
            lastName = n
        }else{
            lastName = ""
            print("there is no lastName key")
        }
        if let n = res["latitude"] as? Double  {
            latitude = n
        }else{
            latitude = 0.0
            print("there is no latitude key")
        }
        if let n = res["longitude"] as? Double  {
            longitude = n
        }else{
            longitude = 0.0
            print("there is no longitude key")
        }
        if let n = res["mapString"] as? String  {
            mapString = n
        }else{
            mapString = ""
            print("there is no mapString key")
        }
        if let n = res["mediaURL"] as? String  {
            mediaURL = n
        }else{
            mediaURL = ""
            print("there is no mediaURL key")
        }
        if let n = res["objectId"] as? String  {
            objectId = n
        }else{
            objectId = ""
            print("there is no objectId key")
        }
        if let n = res["uniqueKey"] as? String  {
            uniqueKey = n
        }else{
            uniqueKey = ""
            print("there is no uniqueKey key")
        }
        if let n = res["updatedAt"] as? String  {
            updatedAt = n
        }else{
            updatedAt = ""
            print("there is no updatedAt key")
        }
        
        
    }
}
