//
//  ImageIdentityHeaderConfig.swift
//  
//
//  Created by Edwin Weru on 07/05/2026.
//

import UIKit


public struct ImageIdentityHeaderConfig {

    // MARK: Image Sources

    /// Remote image URL (preferred source)
    public var imageURL: URL?

    /// Local fallback / placeholder image
    /// Used while loading + when URL fails/nil
    public var image: UIImage?

    // MARK: Content

    public var title: String
    public var subtitle: String?

    // MARK: Accessories

    public var leadingChip: UIView?
    public var trailingChip: UIView?

    // MARK: Layout

    public var imageSize: CGSize = CGSize(width: 72, height: 72)

    public var spacing: CGFloat = 12

    public var contentInsets: UIEdgeInsets = UIEdgeInsets(
        top: 20,
        left: 16,
        bottom: 20,
        right: 16
    )

    // MARK: State

    public var isEnabled: Bool = true
    public var onTap: (() -> Void)?

    // MARK: Card Style

    public var isCardStyleEnabled: Bool = false
    public var cardCornerRadius: CGFloat = 16
    public var cardBackgroundColor: UIColor = .systemBackground

    // MARK: Avatar Styling

    public var avatarBackgroundColor: UIColor = .secondarySystemBackground
    public var avatarContentMode: UIView.ContentMode = .scaleAspectFill
    public var avatarCornerRadius: CGFloat?

    // MARK: Init

    public init(
        imageURL: URL? = nil,
        image: UIImage? = nil,
        title: String,
        subtitle: String? = nil,
        leadingChip: UIView? = nil,
        trailingChip: UIView? = nil,
        onTap: (() -> Void)? = nil,
        isCardStyleEnabled: Bool = false
    ) {
        self.imageURL = imageURL
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.leadingChip = leadingChip
        self.trailingChip = trailingChip
        self.onTap = onTap
        self.isCardStyleEnabled = isCardStyleEnabled
    }
}
