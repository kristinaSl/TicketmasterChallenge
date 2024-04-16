//
//  EventDetailsViewController.swift
//  TicketMasterChallenge
//
//  Created by Kristina Borisova on 14/04/2024.
//

import UIKit

class EventDetailsViewController: UIViewController, EventDetailsViewModelDelegate {
    
    private enum Constant {
        static let padding: CGFloat = 16
    }
    
    private var viewModel: EventDetailsViewModelProtocol
    
    init(viewModel: EventDetailsViewModelProtocol) {
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
        
        self.view.backgroundColor = UIColor.init(named: "backgroundColor")
        self.navigationItem.title = self.viewModel.navigationBarTitle
        
        self.view.addSubview(self._imageView)
        self.view.addSubview(self.infoStackView)
                
        NSLayoutConstraint.activate([
            self._imageView.heightAnchor.constraint(equalToConstant: 360),
            self._imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self._imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self._imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.infoStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constant.padding),
            self.infoStackView.topAnchor.constraint(equalTo: self._imageView.bottomAnchor, constant: Constant.padding),
            self.infoStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constant.padding),
            self.infoStackView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor),
            
        ])
        
        self.viewModel.fetchData()
        
        self.setUpViews()
    }
    
    // MARK: Getters
    
    
    private lazy var infoStackView: UIStackView = {
        
        let infoStackView = UIStackView(arrangedSubviews: [
            self.titleLabel,
            self.loadingSpinner,
            self.promoterLabel
            ])
        
        infoStackView.spacing = 15
        infoStackView.axis = .vertical
        infoStackView.alignment = .leading
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        return infoStackView
    }()
    
    private let _imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.accessibilityIdentifier = "event-details-title-label"
        
        return label
    }()
    
    private let promoterLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private let loadingSpinner: UIActivityIndicatorView = {
        let loadingSpinner = UIActivityIndicatorView()
        loadingSpinner.color = UIColor.init(named: "main")
        loadingSpinner.hidesWhenStopped = true
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        
        return loadingSpinner
    }()
    
    private func setUpViews() {
        self._imageView.imageFromServerURL(self.viewModel.imageURLString, placeHolder: UIImage(named: "placeholder"))
        self.titleLabel.text = self.viewModel.title
    }
    
    func willStartFetchingData(viewModel: EventDetailsViewModelProtocol) {
        self.loadingSpinner.startAnimating()
    }
    
    func didFetchData(viewModel: EventDetailsViewModelProtocol) {
        self.loadingSpinner.stopAnimating()
        self.promoterLabel.text = self.viewModel.promoterName
    }
    
    func didFailWithError(viewModel: EventDetailsViewModelProtocol, error: Error) {
        self.loadingSpinner.stopAnimating()
    }
}
