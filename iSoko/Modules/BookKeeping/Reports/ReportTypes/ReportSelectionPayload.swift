//
//  ReportSelectionPayload.swift
//  
//
//  Created by Edwin Weru on 08/03/2026.
//

import UtilsKit
import Foundation

public struct ReportSelectionPayload {
    public let report: ReportType
    public let timeframe: Timeframe
    public let startDate: Date?
    public let endDate: Date?
}
