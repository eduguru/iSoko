//
//  RemoteInitialsAvatarView.swift
//  iSoko
//
//  Created by Edwin Weru on 18/07/2025.
//

import SwiftUI
import UtilsKit
import NetworkingKit

//RemoteInitialsAvatarView(
//    name: "Sam Admin",
//    url: URL(string: "https://example.com/avatar.jpg"),
//    size: 60
//)


//public struct RemoteInitialsAvatarView: View {
//    private let name: String
//    private let url: URL?
//    private let size: CGFloat
//    private let isCircular: Bool
//    private let cornerRadius: CGFloat
//    private let backgroundStyle: ColorStyle
//    private let foregroundStyle: ColorStyle
//    private let font: UIFont
//
//    @State private var image: UIImage?
//    @State private var isLoading = false
//
//    public init(
//        name: String,
//        url: URL?,
//        size: CGFloat = 80,
//        isCircular: Bool = true,
//        cornerRadius: CGFloat = 12,
//        backgroundStyle: ColorStyle = .accent,
//        foregroundStyle: ColorStyle = .textOnAccent,
//        font: UIFont = .systemFont(ofSize: 32, weight: .medium)
//    ) {
//        self.name = name
//        self.url = url
//        self.size = size
//        self.isCircular = isCircular
//        self.cornerRadius = cornerRadius
//        self.backgroundStyle = backgroundStyle
//        self.foregroundStyle = foregroundStyle
//        self.font = font
//    }
//
//    public var body: some View {
//        InitialsAvatarView(
//            name: name,
//            image: image,
//            isLoading: isLoading,
//            size: size,
//            isCircular: isCircular,
//            cornerRadius: cornerRadius,
//            backgroundStyle: backgroundStyle,
//            foregroundStyle: foregroundStyle,
//            font: font
//        )
//        .onAppear {
//            load()
//        }
//    }
//
//    private func load() {
//        guard let url = url, image == nil else { return }
//        isLoading = true
//        RemoteImageLoader.fetchImage(from: url) { img in
//            self.image = img
//            self.isLoading = false
//        }
//    }
//}
