//
//  AppCoordinator.swift
//  TicketMasterChallenge
//
//  Created by Kristina Borisova on 14/04/2024.
//

import UIKit

protocol Coordinator {
    func start()
}

final class AppCoordinator: Coordinator {
    let window: UIWindow
    var rootViewController: UINavigationController?
    var apiManager: EventsManager?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        do {
            let config = try ConfigLoader.loadConfig()
            
            let server = Server(baseURL: "https://app.ticketmaster.com/discovery/v2", apiKey: config.apiKey)
            let apiManager: EventsManager = { EventsAPIManager(server: server) }()
            self.apiManager = apiManager
            let viewModel = EventsListViewModel(apiManager: apiManager)
            viewModel.onEventSelected = { [weak self] event in
                guard let self = self else { return }
                self.openEventDetails(event)
            }
            
            let eventsListViewController = EventsListViewController(viewModel: viewModel)
            self.rootViewController = UINavigationController(rootViewController: eventsListViewController)
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            appearance.backgroundColor = UIColor(named: "main")
            self.rootViewController?.navigationBar.standardAppearance = appearance;
            self.rootViewController?.navigationBar.scrollEdgeAppearance = self.rootViewController?.navigationBar.standardAppearance
            self.rootViewController?.navigationBar.tintColor = UIColor.white
            self.rootViewController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
            self.rootViewController?.navigationBar.isHidden = false
            
            self.window.rootViewController = self.rootViewController
            self.window.makeKeyAndVisible()
        } catch {
            fatalError("Error: Config file not set up correctly")
        }
    }
    
    func openEventDetails(_ event: Event) {
        guard let apiManager = self.apiManager else { return }
        let viewModel = EventDetailsViewModel(event: event, apiManager: apiManager)
        let viewController = EventDetailsViewController(viewModel: viewModel)
        
        self.rootViewController?.pushViewController(viewController, animated: true)
    }
}
