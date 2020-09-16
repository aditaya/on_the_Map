//
//  UserData.swift
//  On the Map
//
//  Created by Aditya Rana on 14.09.20.
//  Copyright © 2020 Aditya Rana. All rights reserved.
//

import Foundation

struct UserData: Codable {
    let firstName: String
    let lastName: String
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case key
    }
}
