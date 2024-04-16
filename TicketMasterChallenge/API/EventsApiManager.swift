//
//  EventsApiManager.swift
//  TicketMasterChallenge
//
//  Created by Kristina Borisova on 14/04/2024.
//

import Foundation

protocol EventsManager {
    func readAll(_ searchTerm: String?, page: Int, completion: @escaping (([Event]?, EventListPage?), Error?) -> Void)
    func read(eventID: String,completion: @escaping (Event?, Error?) -> Void)

}

final class EventsAPIManager: EventsManager {
    
    let server: Server
    
    required init(server: Server) {
        self.server = server
    }
    
    func readAll(_ searchTerm: String?, page: Int, completion: @escaping (([Event]?, EventListPage?), Error?) -> Void) {
        
        var urlString = "\(self.server.baseURL)/events.json?apikey=\(self.server.apiKey)"
        if let keyword = searchTerm, keyword != "" {
            urlString.append("&keyword=\(keyword)")
        }
        
        if page != 0 {
            urlString.append("&page=\(page)")
        }
        
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "apiError", code: 0, userInfo: ["userInfo": "Error: URL can't be created"])
            completion((nil, nil), error as Error)
            return
        }
                
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion ((nil, nil), error)
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "apiError", code: 0, userInfo: ["userInfo": "Error: No data to decode"])
                completion((nil, nil), error as Error)
                return
            }
            
            guard let eventsList = try? JSONDecoder().decode(EventsList.self, from: data) else {
                guard let page = try? JSONDecoder().decode(EventListPage.self, from: data) else {
                    let error = NSError(domain: "apiError", code: 0, userInfo: ["userInfo": "Error: Couldn't decode data into list of event"])
    completion((nil, nil), error as Error)
                    return
                }
                completion(([], page), nil)

                return
                
            }
            guard let page = try? JSONDecoder().decode(EventListPage.self, from: data) else {
                completion((eventsList.events, nil), nil)
                return
            }
            completion((eventsList.events, page), nil)
        }
        
        task.resume()
    }
    
    func read(eventID: String,completion: @escaping (Event?, Error?) -> Void) {
        let urlString = "\(self.server.baseURL)/events/\(eventID).json?apikey=\(self.server.apiKey)"
        
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "apiError", code: 0, userInfo: ["userInfo": "Error: URL can't be created"])
            completion(nil, error as Error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion (nil, error)
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "apiError", code: 0, userInfo: ["userInfo": "Error: No data to decode"])
                completion(nil, error as Error)
                return
            }
            
            guard let event = try? JSONDecoder().decode(Event.self, from: data) else {
                let error = NSError(domain: "apiError", code: 0, userInfo: ["userInfo": "Error: Couldn't decode data into event"])
                completion(nil, error as Error)
                return
                
            }
            completion(event, nil)
        }
        
        task.resume()
    }
}
