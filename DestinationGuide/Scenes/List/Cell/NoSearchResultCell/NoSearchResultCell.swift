//
//  NoSearchResultCell.swift
//  DestinationGuide
//
//  Created by Bilal on 15/08/2022.
//

import UIKit

final class NoSearchResultCell: UICollectionViewCell {
    //  MARK: - Components

    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Aucune destination ne correspond à votre recherche."
        label.textColor = UIColor.evaneos(color: .ink)
        label.font = UIFont.avertaRegular(fontSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //  MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        isUserInteractionEnabled = false
        self.addView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //  MARK: - Function

    private func addView() {
        self.addSubview(label)
        self.constraintInit()
    }

    private func constraintInit() {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: label.leadingAnchor),
            trailingAnchor.constraint(equalTo: label.trailingAnchor),
            topAnchor.constraint(equalTo: label.topAnchor),
            bottomAnchor.constraint(equalTo: label.bottomAnchor),
        ])
    }
}

extension NoSearchResultCell {
    struct ViewModel {}
}
