//
//  City.swift
//  TicketMasterChallenge
//
//  Created by Kristina Borisova on 15/04/2024.
//

struct City: Decodable {
    
    let name: String

    enum CodingKeys : String, CodingKey {
        case name
    }
}
