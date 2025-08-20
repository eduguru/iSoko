//
//  NetworkLogLevel.swift
//  iSoko
//
//  Created by Edwin Weru on 19/08/2025.
//

public enum NetworkLogLevel {
    case none        // no logs
    case basic       // method, url, status code
    case verbose     // full headers + body
}

public enum NetworkConfig { /// Global log level for all API calls
    public static var logLevel: NetworkLogLevel = .verbose
}
