//
//  RegistrationType.swift
//  
//
//  Created by Edwin Weru on 18/11/2025.
//


public enum RegistrationType: CaseIterable {
    case individual
    case organisation

    var title: String {
        switch self {
        case .individual: return "Personal Information"
        case .organisation: return "Organisation Information"
        }
    }

    var subtitle: String {
        switch self {
        case .individual: return "Tell us about yourself"
        case .organisation: return "Tell us about your organization"
        }
    }
}
