//
//  Dates.swift
//  TicketMasterChallenge
//
//  Created by Kristina Borisova on 15/04/2024.
//

import Foundation

struct Dates: Codable {
    
    struct Start: Codable {
        let localDate: String
        
        enum CodingKeys : String, CodingKey {
            case localDate
        }
    }
    
    let start: Start
    
    enum CodingKeys : String, CodingKey {
        case start
    }
}



