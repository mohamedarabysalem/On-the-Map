//
//  StudentLocationCache.swift
//  onTheMap
//
//  Created by Mohamad Elaraby on 3/23/19.
//  Copyright © 2019 Mohamad Elaraby. All rights reserved.
//

import Foundation

struct StudentInformations : Codable {
    static var shared = StudentInformations()
    private init() {}
    var data = [StudentInformation]()
    
}
