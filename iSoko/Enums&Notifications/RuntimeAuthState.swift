//
//  RuntimeAuthState.swift
//  
//
//  Created by Edwin Weru on 10/02/2026.
//

import StorageKit

enum RuntimeAuthState {
    case guest
    case authenticated
}

enum RuntimeSession {
    static var authState: RuntimeAuthState = .guest
}

enum AuthGate {
    static func requireLogin(
        onFail: () -> Void,
        onSuccess: () -> Void
    ) {
        if AppStorage.hasLoggedIn == true {
            onSuccess()
        } else {
            onFail()
        }
    }
}
