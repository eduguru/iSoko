//
//  UploadFormCell.swift
//  
//
//  Created by Edwin Weru on 09/02/2026.
//

import UIKit

public final class UploadFormCell: UITableViewCell {

    private let container = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let previewImageView = UIImageView()
    private let documentLabel = UILabel()

    private var heightConstraint: NSLayoutConstraint?

    public var onTap: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        container.layer.masksToBounds = true
        contentView.addSubview(container)

        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        heightConstraint = container.heightAnchor.constraint(equalToConstant: 120)
        heightConstraint?.isActive = true

        // preview image
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.clipsToBounds = true
        previewImageView.isHidden = true
        container.addSubview(previewImageView)

        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewImageView.topAnchor.constraint(equalTo: container.topAnchor),
            previewImageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            previewImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            previewImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])

        // document label
        documentLabel.font = .systemFont(ofSize: 14, weight: .medium)
        documentLabel.textColor = .darkGray
        documentLabel.textAlignment = .center
        documentLabel.isHidden = true
        container.addSubview(documentLabel)

        documentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            documentLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            documentLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])

        // icon + text
        container.addSubview(iconView)
        container.addSubview(titleLabel)
        container.addSubview(subtitleLabel)

        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .darkGray

        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .darkGray
        titleLabel.textAlignment = .center

        subtitleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        subtitleLabel.textColor = .gray
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 2

        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            iconView.topAnchor.constraint(equalTo: container.topAnchor, constant: 18),
            iconView.widthAnchor.constraint(equalToConstant: 28),
            iconView.heightAnchor.constraint(equalToConstant: 28),

            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            subtitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12)
        ])

        // Tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        container.addGestureRecognizer(tap)
    }

    @objc private func cellTapped() {
        onTap?()
    }

    public func configure(
        with config: UploadFormRowConfig,
        previewImage: UIImage?,
        documentName: String?
    ) {

        heightConstraint?.constant = config.height
        container.backgroundColor = config.backgroundColor
        container.layer.cornerRadius = config.cornerRadius

        // style
        switch config.style {
        case .dashed:
            container.layer.borderWidth = 1
            container.layer.borderColor = config.borderColor.cgColor

            let dash = CAShapeLayer()
            dash.strokeColor = config.borderColor.cgColor
            dash.lineDashPattern = [6, 6]
            dash.fillColor = nil
            dash.path = UIBezierPath(roundedRect: container.bounds, cornerRadius: config.cornerRadius).cgPath
            dash.frame = container.bounds
            container.layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
            container.layer.addSublayer(dash)

        case .roundedButton:
            container.layer.borderWidth = 1
            container.layer.borderColor = config.borderColor.cgColor
        }

        iconView.image = config.icon
        titleLabel.text = config.title
        subtitleLabel.text = config.subtitle

        // show preview or document name
        if let image = previewImage {
            previewImageView.image = image
            previewImageView.isHidden = false
            documentLabel.isHidden = true
            iconView.isHidden = true
            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
        } else if let name = documentName {
            documentLabel.text = name
            documentLabel.isHidden = false
            previewImageView.isHidden = true
            iconView.isHidden = true
            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
        } else {
            previewImageView.isHidden = true
            documentLabel.isHidden = true
            iconView.isHidden = false
            titleLabel.isHidden = false
            subtitleLabel.isHidden = false
        }
    }
}
