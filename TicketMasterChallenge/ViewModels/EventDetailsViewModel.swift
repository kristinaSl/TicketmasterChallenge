//
//  EventDetailsViewModel.swift
//  TicketMasterChallenge
//
//  Created by Kristina Borisova on 14/04/2024.
//

import Foundation

protocol EventDetailsViewModelDelegate: AnyObject {
    func willStartFetchingData(viewModel: EventDetailsViewModelProtocol)
    func didFetchData(viewModel: EventDetailsViewModelProtocol)
    func didFailWithError(viewModel: EventDetailsViewModelProtocol, error: Error)
}

protocol EventDetailsViewModelProtocol {
    var delegate: EventDetailsViewModelDelegate? { get set }
    var navigationBarTitle: String { get }
    var imageURLString: String { get }
    var title: String { get }
    var promoterName: String { get }

    func fetchData()
}

final class EventDetailsViewModel: EventDetailsViewModelProtocol {
        
    var event: Event
    let apiManager: EventsManager
    
    // MARK: - Initialization
    
    init(event: Event, apiManager: EventsManager) {
        self.event = event
        self.apiManager = apiManager
    }
    
    // MARK: - EventDetailsViewModelProtocol
    
    var delegate: EventDetailsViewModelDelegate?
    
    var navigationBarTitle: String {
        return self.event.name
    }
    
    var imageURLString: String {
                guard let imageURLString = self.event.images.first(where: { $0.height == 360 })?.urlString else {
                    return self.event.images[0].urlString
                }
                return imageURLString
    }
    
    var title: String {
        return self.event.name
    }
    
    func fetchData() {
        self.delegate?.willStartFetchingData(viewModel: self)

        self.apiManager.read(eventID: event.id) { [weak self] eventsResponse, error in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                if let error = error  {
                    self.delegate?.didFailWithError(viewModel: self, error: error)
                } else if let event = eventsResponse {
                    self.event = event
                    self.delegate?.didFetchData(viewModel: self)
                }
            }
        }
    }
    
    
    var promoterName: String {
        guard let promoter = self.event.promoter else {
            return ""
        }
        return promoter.name
    }
}

