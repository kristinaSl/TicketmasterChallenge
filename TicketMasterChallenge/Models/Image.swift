//
//  Image.swift
//  TicketMasterChallenge
//
//  Created by Kristina Borisova on 14/04/2024.
//

import Foundation

struct Image: Decodable {
    
    let urlString: String
    let width: Int
    let height: Int
    
    enum CodingKeys : String, CodingKey {
        case urlString = "url"
        case width
        case height
    }
}
