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
    case countries(page: Int, count: Int)
    case measurementUnits(page: Int, count: Int)
    case measurementMetrics(page: Int, count: Int)
    case ageGroups
    
    case organisationType(page: Int, count: Int)
    case organisationSize(page: Int, count: Int)

    case locations(page: Int, count: Int)
    
    case suppliers(page: Int, count: Int)
    case supplierCategory(page: Int, count: Int)
    
    case expenses(page: Int, count: Int)
    case paymentOptions(page: Int, count: Int)
    
    case customers(page: Int, count: Int)
}
