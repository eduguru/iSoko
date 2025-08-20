//
//  UserDetailsService.swift
//  iSoko
//
//  Created by Edwin Weru on 15/08/2025.
//

import Foundation

public protocol UserDetailsService {
    func getUserDetails() -> UserDetails
    func getOrganizationDetails() -> OrganizationDetails
    func getUserAvatar() -> Data?
    
    func updateUserDetails(_ details: UserDetails)
    func updateOrganizationDetails(_ details: OrganizationDetails)
    func updateUserAvatar(_ avatar: Data)
    func updateUserEmail(_ email: String)
    func updateUserPhone(_ phone: String)
}
