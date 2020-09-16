//
//  PostLocationRequest.swift
//  On the Map
//
//  Created by Aditya Rana on 14.09.20.
//  Copyright © 2020 Aditya Rana. All rights reserved.
//

import Foundation

struct PostLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
}

