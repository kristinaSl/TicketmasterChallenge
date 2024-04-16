//
//  State.swift
//  TicketMasterChallenge
//
//  Created by Kristina Borisova on 15/04/2024.
//

import Foundation

struct State: Decodable {
    
    let name: String
    let stateCode: String

    enum CodingKeys : String, CodingKey {
        case name
        case stateCode
    }
}

