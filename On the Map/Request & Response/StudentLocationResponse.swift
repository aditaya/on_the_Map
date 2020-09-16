//
//  StudentLocationResponse.swift
//  On the Map
//
//  Created by Aditya Rana on 14.09.20.
//  Copyright © 2020 Aditya Rana. All rights reserved.
//

import Foundation


struct StudentLocationResponse: Codable {
    
     let results: [StudentLocation]
        
        enum CodingKeys: String, CodingKey {
            case results
        }
    }

    class StudentsLocationData {
        
        static var studentsData = [StudentLocation]()
     
    }
