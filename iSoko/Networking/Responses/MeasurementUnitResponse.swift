//
//  MeasurementUnitResponse.swift
//  
//
//  Created by Edwin Weru on 27/08/2025.
//

public struct MeasurementUnitResponse: Decodable {
    let id: Int?
    let name: String?
    let code: String?
    let description: String?
    let measurementMetricName: String?
    let measurementMetricId: Int?
}
