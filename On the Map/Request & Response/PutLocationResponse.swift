//
//  PutLocationResponse.swift
//  On the Map
//
//  Created by Aditya Rana on 14.09.20.
//  Copyright © 2020 Aditya Rana. All rights reserved.
//

import Foundation

struct PutLocationResponse: Codable {
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
            case updatedAt
        }
    }
