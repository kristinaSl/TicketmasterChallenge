//
//  UITestScreenNavigable.swift
//  TicketMasterChallengeUITests
//
//  Created by Kristina Borisova on 16/04/2024.
//

import Foundation

/// Protocol that allows a `UITestScreen` to define how it is successfully navigated.
/// Also allows a screen to specify how it should wait for itself to appear. By default this uses the `await()` function.
protocol UITestScreenNavigable {
    func complete()
    func cancel()
    func waitUntilViewable()
}

extension UITestScreenNavigable where Self: UITestScreen {
    
    func complete() { }
    
    func cancel() { }
    
    func waitUntilViewable() {
        wait()
    }
}
