//
//  EditableImageIdentityHeaderConfig.swift
//  
//
//  Created by Edwin Weru on 28/05/2026.
//

import UIKit

public struct EditableImageIdentityHeaderConfig {

    public var imageURL: URL?
    public var image: UIImage?

    public var title: String
    public var subtitle: String?

    public var leadingChip: UIView?
    public var trailingChip: UIView?

    public var imageSize: CGSize = CGSize(width: 72, height: 72)

    public var onProfileImageTap: (() -> Void)?
    public var onEditImageTap: (() -> Void)?

    public init(
        imageURL: URL? = nil,
        image: UIImage? = nil,
        title: String,
        subtitle: String? = nil,
        leadingChip: UIView? = nil,
        trailingChip: UIView? = nil,
        onProfileImageTap: (() -> Void)? = nil,
        onEditImageTap: (() -> Void)? = nil
    ) {
        self.imageURL = imageURL
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.leadingChip = leadingChip
        self.trailingChip = trailingChip
        self.onProfileImageTap = onProfileImageTap
        self.onEditImageTap = onEditImageTap
    }
}
