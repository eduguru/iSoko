//
//  EditableImageIdentityHeaderConfig.swift
//  
//
//  Created by Edwin Weru on 28/05/2026.
//

import UIKit

public struct EditableImageIdentityHeaderConfig {

    // MARK: Images

    /// Remote persisted profile image
    public var imageURL: URL?

    /// Local temporary override image (picked by user)
    public var localImage: UIImage?

    /// Placeholder/default image
    public var placeholderImage: UIImage?

    // MARK: Text

    public var title: String
    public var subtitle: String?

    // MARK: Chips

    public var leadingChip: UIView?
    public var trailingChip: UIView?

    // MARK: Layout

    public var imageSize: CGSize = CGSize(width: 72, height: 72)

    // MARK: Actions

    public var onProfileImageTap: (() -> Void)?
    public var onEditImageTap: (() -> Void)?

    // MARK: Init

    public init(
        imageURL: URL? = nil,
        localImage: UIImage? = nil,
        placeholderImage: UIImage? = nil,
        title: String,
        subtitle: String? = nil,
        leadingChip: UIView? = nil,
        trailingChip: UIView? = nil,
        onProfileImageTap: (() -> Void)? = nil,
        onEditImageTap: (() -> Void)? = nil
    ) {
        self.imageURL = imageURL
        self.localImage = localImage
        self.placeholderImage = placeholderImage
        self.title = title
        self.subtitle = subtitle
        self.leadingChip = leadingChip
        self.trailingChip = trailingChip
        self.onProfileImageTap = onProfileImageTap
        self.onEditImageTap = onEditImageTap
    }
}
