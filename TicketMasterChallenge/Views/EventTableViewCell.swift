//
//  EventTableViewCell.swift
//  TicketMasterChallenge
//
//  Created by Kristina Borisova on 14/04/2024.
//

import UIKit

final class EventTableViewCell: UITableViewCell {
    
    private enum Constant {
        static let padding: CGFloat = 16
        static let imageSize: CGSize = CGSize(width: 120, height: 120)
    }
   
    var onButtonAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.isAccessibilityElement = true
        self.setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        self.backgroundColor = .clear
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.23
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.black.cgColor
        
        contentView.addSubview(self.mainStackView)
        contentView.backgroundColor = .clear
        
        self.infoView.addSubview(infoStackView)
        
        NSLayoutConstraint.activate([
            _imageView.widthAnchor.constraint(equalToConstant: Constant.imageSize.width),
            _imageView.heightAnchor.constraint(equalToConstant: Constant.imageSize.height),
            
            self.mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.padding),
            self.mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.padding),
            self.mainStackView.trailingAnchor.constraint(equalTo:  contentView.trailingAnchor, constant: -Constant.padding),
            self.mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.padding),
            
            self.infoStackView.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 10),
            self.infoStackView.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 5),
            self.infoStackView.trailingAnchor.constraint(lessThanOrEqualTo: infoView.trailingAnchor, constant: -5),
            self.infoStackView.bottomAnchor.constraint(lessThanOrEqualTo: infoView.bottomAnchor, constant: -5)
        ])

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self._imageView.cancelImageDownload()
        self._imageView.image = nil
        self.titleLabel.text = nil
        self.dateLabel.text = nil
        self.venueLabel.text = nil
        self.locationLabel.text = nil
    }
    
    // MARK: Getters

    private lazy var _imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.layer.cornerCurve = .continuous
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private let venueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        
        let stackView = UIStackView(arrangedSubviews: [
            self.titleLabel,
            self.dateLabel,
            self.venueLabel,
            self.locationLabel
            ])
        
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.distribution = .equalSpacing
        
        return stackView
    }()

    private lazy var infoView: UIView = UIView()
    
    private lazy var mainStackView: UIStackView = {
        
        let stackView = UIStackView(arrangedSubviews: [
            self._imageView,
            self.infoView,
            ])
        
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 4
        stackView.layer.cornerCurve = .continuous
        stackView.backgroundColor = .white
        
        return stackView
    }()


    // MARK: Setters
    
    func setImageWithString(_ urlString: String) {
        self._imageView.imageFromServerURL(urlString, placeHolder: UIImage(named: "placeholder"))
    }
    
    func configureCellWith(title: String, date: String, venue: String, location: String) {
        self.titleLabel.text = title
        self.dateLabel.text = date
        self.venueLabel.text = venue
        self.locationLabel.text = location
    }
}

