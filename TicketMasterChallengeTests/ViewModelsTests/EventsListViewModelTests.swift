//
//  EventsListViewModelTests.swift
//  TicketMasterChallengeTests
//
//  Created by Kristina Borisova on 15/04/2024.
//

import XCTest

@testable import TicketMasterChallenge

class EventsListViewModelTests: XCTestCase {
    
    class SpyDelegate: EventsListViewModelDelegate {
        
        var willFetchDataCalled = false
        let didFetchDataCalled = XCTestExpectation(description: "Did fetch data")
        let didFailWithErrorCalled = XCTestExpectation(description: "Did fail with error")
        
        func willStartFetchingData(viewModel: EventsListViewModelProtocol) {
            self.willFetchDataCalled = true
        }
        
        func didFetchData(viewModel: EventsListViewModelProtocol) {
            self.didFetchDataCalled.fulfill()
        }
        
        func didFailWithError(viewModel: EventsListViewModelProtocol, error: Error) {
            self.didFailWithErrorCalled.fulfill()
        }
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func testFetchDataSuccess() {
        
        let apiManager = MockEventsApiManagerSuccess()
        let viewModel = EventsListViewModel(apiManager: apiManager)
        
        let spyDelegate = SpyDelegate()
        viewModel.delegate = spyDelegate
        viewModel.fetchData()
        
        XCTAssertTrue(spyDelegate.willFetchDataCalled)
        wait(for: [spyDelegate.didFetchDataCalled], timeout: 1)
    }
    
    func testFetchDataFail() {
        let apiManager = MockEventsApiManagerFail()
        let viewModel = EventsListViewModel(apiManager: apiManager)
        
        let spyDelegate = SpyDelegate()
        viewModel.delegate = spyDelegate
        viewModel.fetchData()
        
        XCTAssertTrue(spyDelegate.willFetchDataCalled)
        wait(for: [spyDelegate.didFailWithErrorCalled], timeout: 1)
    }
    
    func testFetchNextDataSuccess() {
        
        let apiManager = MockEventsApiManagerSuccess()
        let viewModel = EventsListViewModel(apiManager: apiManager)
        viewModel.eventsListPage = EventListPage(page: Page(size: 20, totalElements: 100, totalPages: 5, number: 0))
        
        let spyDelegate = SpyDelegate()
        viewModel.delegate = spyDelegate
        viewModel.fetchNextPage()

        wait(for: [spyDelegate.didFetchDataCalled], timeout: 1)
    }
}
