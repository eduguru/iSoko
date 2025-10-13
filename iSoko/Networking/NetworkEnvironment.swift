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
    public let authenticationService: AuthenticationServiceImp
    public let userDetailsService: UserDetailsServiceImpl
    public let commonUtilitiesService: CommonUtilitiesServiceImpl
    public let servicesService: ServicesServiceImpl
    public let productsService: ProductsServiceImpl
    
    

    // MARK: - Init
    private init() {
        // Create token provider
        self.tokenProvider = AppTokenProvider()

        // Create network provider with token provider
        self.networkProvider = NetworkProvider(tokenProvider: tokenProvider)

        // Init services
        self.certificateService = CertificateServiceImpl( provider: networkProvider, tokenProvider: tokenProvider)
        self.authenticationService = AuthenticationServiceImp(provider: networkProvider, tokenProvider: tokenProvider)
        self.userDetailsService = UserDetailsServiceImpl(provider: networkProvider, tokenProvider: tokenProvider)
        
        self.commonUtilitiesService = CommonUtilitiesServiceImpl(provider: networkProvider, tokenProvider: tokenProvider)
        self.servicesService = ServicesServiceImpl(provider: networkProvider, tokenProvider: tokenProvider)
        self.productsService = ProductsServiceImpl(provider: networkProvider, tokenProvider: tokenProvider)
    }
}
