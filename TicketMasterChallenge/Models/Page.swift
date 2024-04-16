//
//  Page.swift
//  TicketMasterChallenge
//
//  Created by Kristina Borisova on 16/04/2024.
//

import Foundation

struct Page: Decodable {
    
    let size: Int
    let totalElements: Int
    let totalPages: Int
    let number: Int

    enum CodingKeys : String, CodingKey {
        case size
        case totalElements
        case totalPages
        case number
    }
}
