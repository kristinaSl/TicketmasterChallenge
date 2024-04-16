//
//  UITestScreen.swift
//  TicketMasterChallengeUITests
//
//  Created by Kristina Borisova on 16/04/2024.
//
import XCTest

protocol UITestScreen: AnyObject {
    var trait: XCUIElement { get }
}

extension UITestScreen {
    
    // MARK: Internal
    
    /// Use primarily to assert that you're on the correct screen - all screens should try to have a trait element.
    /// If the trait is static it can be declared in the init() function of a page, if you want it to be dynamic you can pass it an element to use as a trait
    func wait(file: StaticString = #file, line: UInt = #line, maxDuration: TimeInterval = 30) {
        waitForElementToAppear(trait, maxDuration: maxDuration, file: file, line: line)
    }
    
    /// Waits for an element to appear and raises a failure if it doesn't appear in the specified time
    ///
    /// - Parameters:
    ///   - element: Element that's supposed to appear
    ///   - maxDuration: Maximum wait time
    func waitForElementToAppear(_ element: XCUIElement, maxDuration: TimeInterval = 30, file: StaticString = #file, line: UInt = #line) {
        waitForExistence(element, maxDuration: maxDuration, file: file, line: line)
        guard !element.isHittable else { return }
        let expectation = XCTestExpectation(description: "Waiting for element \(element.debugDescription) to become hittable")
        waitForElementToBecomeHittable(element, expectation: expectation, maxDuration: maxDuration)
        waitForExpectationTimeOutOrCompletion(expectation: expectation, maxDuration: maxDuration, file: file, line: line)
    }
    
    /// Waits for an element to have a non-empty value and raises a failure if it doesn't in the specified time
    ///
    /// - Parameters:
    ///   - element: The element to wait for
    ///   - maxDuration: Maximum wait time
    func waitForElementToHaveNonEmptyValue(_ element: XCUIElement, maxDuration: Double = 20, file: StaticString = #file, line: UInt = #line) {
        waitForExistence(element, maxDuration: maxDuration, file: file, line: line)
        let expectation = XCTestExpectation(description: "Waiting for element \(element.debugDescription) to have a value")
        if (element.value as? String)?.isEmpty == false {
            return
        }
        waitForElementValue(element, expectation: expectation, maxDuration: maxDuration)
        waitForExpectationTimeOutOrCompletion(expectation: expectation, maxDuration: maxDuration, file: file, line: line)
    }
    
    /// Waits for an element to disappear
    ///
    /// - Parameters:
    ///   - element: The element to wait for
    ///   - maxDuration: Maximum wait time
    func waitForElementToDisappear(_ element: XCUIElement, maxDuration: Double = 20, file: StaticString = #file, line: UInt = #line) {
        if element.waitForExistence(timeout: maxDuration) && element.isHittable {
            XCTFail("Timed out waiting for element: -\(element)- to disappear.", file: file, line: line)
        }
    }
    
    /// Taps the native back button, using the previous screen's title as the back button title.
    func tapNativeBackButton() {
        App.shared.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    // MARK: Private
    
    private func waitForExistence(_ element: XCUIElement, maxDuration: Double, file: StaticString, line: UInt) {
        guard !element.exists else { return }
        XCTAssertTrue(element.waitForExistence(timeout: maxDuration), "Failed while waiting for element \(element.debugDescription) to appear.", file: file, line: line)
    }
    
    private func waitForElementToBecomeHittable(_ element: XCUIElement, expectation: XCTestExpectation, maxDuration: TimeInterval) {
        if !element.isHittable {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.waitForElementToBecomeHittable(element, expectation: expectation, maxDuration: maxDuration)
            }
        } else {
            expectation.fulfill()
        }
    }
    
    private func waitForElementValue(_ element: XCUIElement, expectation: XCTestExpectation, maxDuration: TimeInterval) {
        if (element.value as? String)?.isEmpty == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.waitForElementValue(element, expectation: expectation, maxDuration: maxDuration)
            }
        } else {
            expectation.fulfill()
        }
    }
    
    private func waitForExpectationTimeOutOrCompletion(expectation: XCTestExpectation, maxDuration: Double, file: StaticString, line: UInt) {
        switch XCTWaiter.wait(for: [expectation], timeout: maxDuration) {
        case .completed: return
        case .incorrectOrder, .interrupted, .invertedFulfillment, .timedOut: XCTFail(expectation.description, file: file, line: line)
        @unknown default:
            XCTFail(expectation.description, file: file, line: line)
        }
    }
}
