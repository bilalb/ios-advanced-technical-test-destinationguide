//
//  DestinationCell.swift
//  DestinationGuide
//
//  Created by Bilal on 12/08/2022.
//

import UIKit

final class DestinationCell: UICollectionViewCell {

    private var dataTask: URLSessionDataTask?

    //  MARK: - Components

    private let labelDestination: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Asie"
        label.font = UIFont.avertaExtraBold(fontSize: 38)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //  Bouton plutôt qu'un label pour pouvoir mettre un padding
    //  Evite d'imbriquer un label dans une UIView

    private let labelTag: UIButton = {
        let lbl = UIButton()
        lbl.setTitle("Test", for: .normal)
        lbl.setTitleColor(.white, for: .normal)
        lbl.contentEdgeInsets = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
        lbl.titleLabel?.font = UIFont.avertaBold(fontSize: 16)
        lbl.isUserInteractionEnabled = false
        lbl.backgroundColor = UIColor.evaneos(color: .ink)
        lbl.layer.cornerRadius = 5
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let stackViewRating: UIStackView = {
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let imageViewBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var gradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.startColor = .black.withAlphaComponent(0)
        gradientView.endColor = .black.withAlphaComponent(0.5)

        return gradientView
    }()

    //  MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .clear

        self.shadow()
        self.addView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.gradientView.frame = imageViewBackground.frame

        self.imageViewBackground.addSubview(gradientView)
        self.backgroundView = self.imageViewBackground
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //  MARK: - Override func

    override func prepareForReuse() {
        super.prepareForReuse()
        self.stackViewRating.arrangedSubviews.forEach {
            NSLayoutConstraint.deactivate($0.constraints)
            $0.removeFromSuperview()
        }
        self.labelDestination.text = nil

        self.dataTask?.cancel()
    }

    private func downloadImage(url: URL) {
        self.dataTask?.resume()

        self.dataTask = URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: { data, _, _  in
            if let data = data {
                DispatchQueue.main.async {
                    self.imageViewBackground.image = UIImage(data: data)
                }
            }
        })

        self.dataTask?.resume()
    }

    //  MARK: - Function

    func setupCell(viewModel: ViewModel) {
        self.labelDestination.text = viewModel.name
        self.configureStackView(rating: viewModel.rating)
        self.labelTag.setTitle(viewModel.tag, for: .normal)

        self.downloadImage(url: viewModel.imageURL)

        self.dataTask?.resume()
    }

    private func shadow() {
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4.0)
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 4.0
    }

    private func addView() {

        self.addSubview(labelTag)
        self.addSubview(labelDestination)
        self.addSubview(stackViewRating)

        self.constraintInit()
    }

    private func configureStackView(rating: Int) {
        var stars = [UIImageView]()

        for i in 0..<5 {
            let imageView = UIImageView()
            imageView.tintColor = UIColor.evaneos(color: .gold)
            if i < rating {
                let image = UIImage(systemName: "star.fill")
                imageView.image = image
            } else {
                let image = UIImage(systemName: "star")
                imageView.image = image
            }
            stars.append(imageView)
        }

        for star in stars {
            self.stackViewRating.addArrangedSubview(star)
        }
    }

    private func constraintInit() {
        NSLayoutConstraint.activate([
            self.labelTag.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.labelTag.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.labelTag.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),

            self.stackViewRating.bottomAnchor.constraint(equalTo: self.labelTag.topAnchor, constant: -8),
            self.stackViewRating.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),

            self.labelDestination.bottomAnchor.constraint(equalTo: self.stackViewRating.topAnchor, constant: 0),
            self.labelDestination.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.labelDestination.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 16)
        ])
    }

}
