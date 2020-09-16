//
//  PostLocationResponse.swift
//  On the Map
//
//  Created by Aditya Rana on 14.09.20.
//  Copyright © 2020 Aditya Rana. All rights reserved.
//

import Foundation
struct PostLocationResponse: Codable {
    let createAt: String
    let objectId: String
    
        enum CodingKeys: String, CodingKey {
            case createAt
            case objectId
        }
    }
