//
//  SectionHeader.swift
//  DestinationGuide
//
//  Created by Bilal on 12/08/2022.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.avertaBold(fontSize: 28)

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutMargins = .init(top: 8, left: 16, bottom: 8, right: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            self.layoutMarginsGuide.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            self.layoutMarginsGuide.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            self.layoutMarginsGuide.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            self.layoutMarginsGuide.topAnchor.constraint(equalTo: titleLabel.topAnchor),
        ])

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
