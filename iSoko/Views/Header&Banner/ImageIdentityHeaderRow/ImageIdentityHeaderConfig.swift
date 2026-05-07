//
//  ImageIdentityHeaderConfig.swift
//  
//
//  Created by Edwin Weru on 07/05/2026.
//

import UIKit

public struct ImageIdentityHeaderConfig {

    public var image: UIImage?
    public var title: String
    public var subtitle: String?

    public var leadingChip: UIView?
    public var trailingChip: UIView?

    public var imageSize: CGSize = CGSize(width: 72, height: 72)

    public var spacing: CGFloat = 12
    public var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)

    public var isEnabled: Bool = true
    public var onTap: (() -> Void)?

    public var isCardStyleEnabled: Bool = false
    public var cardCornerRadius: CGFloat = 16
    public var cardBackgroundColor: UIColor = .systemBackground

    public init(
        image: UIImage?,
        title: String,
        subtitle: String?,
        leadingChip: UIView? = nil,
        trailingChip: UIView? = nil,
        onTap: (() -> Void)? = nil,
        isCardStyleEnabled: Bool = false
    ) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.leadingChip = leadingChip
        self.trailingChip = trailingChip
        self.onTap = onTap
        self.isCardStyleEnabled = isCardStyleEnabled
    }
}
