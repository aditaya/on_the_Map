//
//  StudentLocation.swift
//  On the Map
//
//  Created by Aditya Rana on 03.09.20.
//  Copyright © 2020 Aditya Rana. All rights reserved.
//

import Foundation



struct StudentLocation: Codable {
    
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Float
    let longitude: Float
    let mapString: String
    let mediaURL: String
    let objectID: String
    let uniqueKey: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "createdAt"
        case firstName = "firstName"
        case lastName = "lastName"
        case latitude = "latitude"
        case longitude = "longitude"
        case mapString = "mapString"
        case mediaURL = "mediaURL"
        case objectID = "objectId"
        case uniqueKey = "uniqueKey"
        case updatedAt = "updatedAt"
        
    }

}
