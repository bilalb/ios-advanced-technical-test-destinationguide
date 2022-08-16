//
//  RecentDestinationCell.swift
//  DestinationGuide
//
//  Created by Bilal on 13/08/2022.
//

import UIKit

final class RecentDestinationCell: UICollectionViewCell {
    // MARK: - Components

    // `UIButton` allows to configure `contentInsets` unlike `UILabel`.
    private let nameLabel: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.evaneos(color: .ink), for: .normal)
        button.configuration = .plain()
        button.configuration?.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        button.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.avertaBold(fontSize: 18)
            return outgoing
        }
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.evaneos(color: .ink).cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Function

    func setupCell(viewModel: ViewModel) {
        nameLabel.setTitle(viewModel.name, for: .normal)
    }
}

// MARK: - Private Methods

private extension RecentDestinationCell {
    func addView() {
        self.addSubview(nameLabel)
        self.constraintInit()
    }

    func constraintInit() {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            topAnchor.constraint(equalTo: nameLabel.topAnchor),
            bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
        ])
    }
}
