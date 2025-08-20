//
//  NetworkEnvironment.swift
//  iSoko
//
//  Created by Edwin Weru on 20/08/2025.
//

public struct NetworkEnvironment {
    // Shared instance (singleton-like)
    public static let shared = NetworkEnvironment()

    // MARK: - Providers
    public let tokenProvider: AppTokenProvider
    public let networkProvider: NetworkProvider

    // MARK: - Services
    public let certificateService: CertificateServiceImpl

    // MARK: - Init
    private init() {
        // Create token provider
        self.tokenProvider = AppTokenProvider()

        // Create network provider with token provider
        self.networkProvider = NetworkProvider(tokenProvider: tokenProvider)

        // Init services
        self.certificateService = CertificateServiceImpl(
            provider: networkProvider,
            tokenProvider: tokenProvider
        )
    }
}
