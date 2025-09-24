//
//  CommonUtilityOption.swift
//
//
//  Created by Edwin Weru on 24/09/2025.
//


//MARK: - for easier application -
public enum CommonUtilityOption {
    case userRoles(page: Int, count: Int)
    case userTypes(page: Int, count: Int)
    case userGender(page: Int, count: Int)
    case organisationType(page: Int, count: Int)
    case organisationSize(page: Int, count: Int)

    case ageGroups
    case locations(page: Int, count: Int)
    //we add more cases as needed
}
