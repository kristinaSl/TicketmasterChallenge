//
//  NavigationContext.swift
//  TicketMasterChallengeUITests
//
//  Created by Kristina Borisova on 16/04/2024.
//

import UIKit

import XCTest

protocol NavigationContext {}
extension NavigationContext {
    
    func complete(screens: [UITestScreenNavigable]) {
        screens.forEach { complete($0) }
    }
    
    func complete(_ screen: UITestScreenNavigable) {
        screen.waitUntilViewable()
        screen.complete()
    }
    
    func dismiss(theScreen screen: UITestScreenNavigable) {
        screen.cancel()
    }
    
    func see(theScreen screen: UITestScreenNavigable) {
        screen.waitUntilViewable()
    }
    
}
