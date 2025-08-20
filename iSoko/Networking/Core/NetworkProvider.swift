//
//  NetworkProvider.swift
//  iSoko
//
//  Created by Edwin Weru on 19/08/2025.
//

import Foundation

public final class NetworkProvider {
    private let tokenProvider: RefreshableTokenProvider

    public init(tokenProvider: RefreshableTokenProvider) {
        self.tokenProvider = tokenProvider
    }

    public func manager() -> NetworkManager<AnyTarget> {
        return NetworkManager<AnyTarget>(tokenProvider: tokenProvider)
    }
}
