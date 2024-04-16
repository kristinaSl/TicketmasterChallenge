//
//  EventDetailsViewModelTests.swift
//  TicketMasterChallengeTests
//
//  Created by Kristina Borisova on 16/04/2024.
//

import XCTest

@testable import TicketMasterChallenge

class EventDetailsViewModelTests: XCTestCase {
    
    class SpyDelegate: EventDetailsViewModelDelegate {
        
        var willFetchDataCalled = false
        let didFetchDataCalled = XCTestExpectation(description: "Did fetch data")
        let didFailWithErrorCalled = XCTestExpectation.init(description: "Did fail with error")
        
        func willStartFetchingData(viewModel: EventDetailsViewModelProtocol) {
            self.willFetchDataCalled = true
        }
        
        func didFetchData(viewModel: EventDetailsViewModelProtocol) {
            self.didFetchDataCalled.fulfill()
        }
        
        func didFailWithError(viewModel: EventDetailsViewModelProtocol, error: Error) {
            self.didFailWithErrorCalled.fulfill()
        }
    }
    
    override func setUpWithError() throws {
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: "event", withExtension: "json") else {
            XCTFail("Missing file: event.json")
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            XCTFail("Can't create data")
            return
        }
        
        self.event = try? JSONDecoder().decode(Event.self, from: data)
    }

    override func tearDownWithError() throws {
        self.event = nil
    }
    
    var event: Event?

    func testFetchDataSuccess() {
        
        guard let event = self.event else { return }

        let apiManager = MockEventsApiManagerSuccess()
        let viewModel = EventDetailsViewModel(event: event, apiManager: apiManager)
        
        let spyDelegate = SpyDelegate()
        viewModel.delegate = spyDelegate
        viewModel.fetchData()
        
        XCTAssertTrue(spyDelegate.willFetchDataCalled)
        wait(for: [spyDelegate.didFetchDataCalled], timeout: 1)
    }
    
    func testFetchDataFail() {
        guard let event = self.event else { return }

        let apiManager = MockEventsApiManagerFail()
        let viewModel = EventDetailsViewModel(event: event, apiManager: apiManager)
        
        let spyDelegate = SpyDelegate()
        viewModel.delegate = spyDelegate
        viewModel.fetchData()
        
        XCTAssertTrue(spyDelegate.willFetchDataCalled)
        wait(for: [spyDelegate.didFailWithErrorCalled], timeout: 1)
    }
}
