//
//  EventsListViewModel.swift
//  TicketMasterChallenge
//
//  Created by Kristina Borisova on 14/04/2024.
//

import Foundation

protocol EventsListViewModelDelegate: AnyObject {
    func willStartFetchingData(viewModel: EventsListViewModelProtocol)
    func didFetchData(viewModel: EventsListViewModelProtocol)
    func didFailWithError(viewModel: EventsListViewModelProtocol, error: Error)
}

protocol EventsListViewModelProtocol {
    var delegate: EventsListViewModelDelegate? { get set }
    var navigationBarTitle: String { get }
    var numberOfRows: Int { get }
    func fetchData()
    func fetchNextPage()
    func eventAtIndex(_ index: Int) -> Event
    func didSelectEventAtIndex(_ index: Int)
    func userHaveSerachedFor(_ searchTerm: String)
}

final class EventsListViewModel: EventsListViewModelProtocol {
    
    let apiManager: EventsManager
    var onEventSelected: ((Event) -> Void)?
    var serachTerm: String = ""
    
    // MARK: - Initialization
    
    init(apiManager: EventsManager) {
        self.apiManager = apiManager
    }
    
   private var events: [Event] = []
   public var eventsListPage: EventListPage?
    
    // MARK: - EventsListViewModelProtocol

    var numberOfRows: Int {
        return self.events.count
    }
    
    var delegate: EventsListViewModelDelegate?
    
    let navigationBarTitle: String = NSLocalizedString("EventsListControllerNavigationBarTitle", comment: "")
    
    private func getData(_ searchTerm: String?) {
        self.delegate?.willStartFetchingData(viewModel: self)
        
        self.apiManager.readAll(searchTerm, page: 0) { [weak self] eventsResponse, error in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                if let error = error  {
                    self.delegate?.didFailWithError(viewModel: self, error: error)
                } else {
                    if let events = eventsResponse.0 {
                        self.events = events
                    }
                    self.eventsListPage = eventsResponse.1
                    self.delegate?.didFetchData(viewModel: self)
                }
            }
        }
    }
    
    func fetchData() {
        self.getData(nil)
    }
    
    func fetchNextPage() {
        guard let page = self.eventsListPage else { return }
        
        guard page.page.totalPages != page.page.number else { return }
        
        self.apiManager.readAll(self.serachTerm, page: page.page.number + 1) { [weak self] eventsResponse, error in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                if let error = error  {
                    self.delegate?.didFailWithError(viewModel: self, error: error)
                } else {
                    if let events = eventsResponse.0 {
                        self.events.append(contentsOf: events)
                    }
                    self.eventsListPage = eventsResponse.1
                    self.delegate?.didFetchData(viewModel: self)
                }
            }
        }
    }
    
    func eventAtIndex(_ index: Int) -> Event {
        return self.events[index]
    }
    
    func didSelectEventAtIndex(_ index: Int) {
        self.onEventSelected?(self.events[index])
    }
    
    func userHaveSerachedFor(_ searchTerm: String) {
        self.serachTerm = searchTerm
        self.getData(searchTerm)
    }
}


