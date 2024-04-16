//
//  EventsListViewController.swift
//  TicketMasterChallenge
//
//  Created by Kristina Borisova on 14/04/2024.
//

import UIKit

class EventsListViewController: UIViewController, EventsListViewModelDelegate, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    private enum Constant {
        static let padding: CGFloat = 16
    }
    
    private var viewModel: EventsListViewModelProtocol
    
    private var previousSearchTerm: String = ""

    init(viewModel: EventsListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.searchResultsUpdater = self
        self.navigationItem.searchController = self.searchBar
        self.navigationItem.title = self.viewModel.navigationBarTitle
        
        self.view.backgroundColor = UIColor.init(named: "backgroundColor")
        
        self.view.addSubview(self.loadingSpinner)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.noEventsFoundLabel)
                
        self.tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "EventTableViewCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        NSLayoutConstraint.activate([
            self.loadingSpinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.loadingSpinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            self.noEventsFoundLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.noEventsFoundLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            self.noEventsFoundLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.noEventsFoundLabel.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.noEventsFoundLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.noEventsFoundLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        self.noEventsFoundLabel.isHidden = true
        
        self.viewModel.fetchData()
    }
    
    // MARK: Getters
    
    private let loadingSpinner: UIActivityIndicatorView = {
        let loadingSpinner = UIActivityIndicatorView()
        loadingSpinner.color = UIColor.init(named: "main")
        loadingSpinner.hidesWhenStopped = true
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        
        return loadingSpinner
    }()
    
    private let searchBar: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = NSLocalizedString("EventsListControllerSearchBarPlaceholder", comment: "")
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.barStyle = .black
        
        return searchController
        
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.accessibilityIdentifier = "events-table-view"
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private let noEventsFoundLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = NSLocalizedString("EventsListControllerNoEvents", comment: "")
        
        return label
    }()
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        let event = self.viewModel.eventAtIndex(indexPath.row)
        
        let location = event.embedded.venues[0].city.name + ", " + (event.embedded.venues[0].state?.stateCode ?? "")
        cell.configureCellWith(title: event.name, date: event.dates.start.localDate, venue: event.embedded.venues[0].name, location: location)
        
        if let imageURLString = event.images.first(where: { $0.height == 115 })?.urlString {
            cell.setImageWithString(imageURLString)
        } else {
            cell.setImageWithString(event.images[0].urlString)
        }
        
        cell.selectionStyle = .none
        cell.accessibilityIdentifier = "EventTableViewCell_\(indexPath.row)"
        
        loadMoreDataIfNeeded(for: indexPath)

        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.didSelectEventAtIndex(indexPath.row)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: CharactersViewModelDelegate
    
    func willStartFetchingData(viewModel: EventsListViewModelProtocol) {
        self.loadingSpinner.startAnimating()
        self.tableView.isHidden = true
        self.noEventsFoundLabel.isHidden = true
    }
    
    func didFetchData(viewModel: EventsListViewModelProtocol) {
        self.loadingSpinner.stopAnimating()
        if self.viewModel.numberOfRows > 0 {
            self.noEventsFoundLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        } else {
            self.noEventsFoundLabel.isHidden = false
        }
    }
    
    func didFailWithError(viewModel: EventsListViewModelProtocol, error: Error) {
        self.loadingSpinner.stopAnimating()
        self.tableView.isHidden = true
        self.noEventsFoundLabel.isHidden = true
        
        let alertController = UIAlertController(title: NSLocalizedString("FoundationError", comment: ""),
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("FoundationCancel", comment: ""), style: .cancel)
        let retryAction = UIAlertAction(title: NSLocalizedString("FoundationRetry", comment: ""), style: .default) { _ in
            self.viewModel.fetchData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(retryAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text != self.previousSearchTerm else { return }
        self.previousSearchTerm = text
        self.viewModel.userHaveSerachedFor(text)
    }
    
    // MARK: Private
    
    private func loadMoreDataIfNeeded(for indexPath: IndexPath) {
        if indexPath.row == self.viewModel.numberOfRows - 3  {
            self.viewModel.fetchNextPage()
        }
    }

}
