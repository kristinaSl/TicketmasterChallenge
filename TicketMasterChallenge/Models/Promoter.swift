//
//  Promoter.swift
//  TicketMasterChallenge
//
//  Created by Kristina Borisova on 16/04/2024.
//

import Foundation

struct Promoter: Decodable {
    
    let id: String
    let name: String
    let description: String
    
    enum CodingKeys : String, CodingKey {
        case id
        case name
        case description
    }
}
