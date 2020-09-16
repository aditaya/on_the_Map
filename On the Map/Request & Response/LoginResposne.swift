//
//  LoginResposne.swift
//  On the Map
//
//  Created by Aditya Rana on 14.09.20.
//  Copyright © 2020 Aditya Rana. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    
       let account: Account
        let session: Session
        
        enum CodingKeys: String, CodingKey { case account, session }
    }

    struct Account: Codable {
        let registered: Bool
        let key: String
        
        enum CodingKeys: String, CodingKey { case registered, key }
    }

    struct Session: Codable {
        let id: String
        let expiration: String
        
        enum CodingKeys: String, CodingKey { case id, expiration }
    }
