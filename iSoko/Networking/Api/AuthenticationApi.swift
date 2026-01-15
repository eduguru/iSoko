//
//  AuthenticationApi.swift
//  iSoko
//
//  Created by Edwin Weru on 15/08/2025.
//
import Moya
import Foundation
import UtilsKit
import NetworkingKit
import UIKit

public struct AuthenticationApi {
    
    public static func login(
        grant_type: String,
        client_id: String,
        client_secret: String,
        username: String,
        password: String
    ) -> ValueResponseTarget<TokenModel> {
        
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        let parameters = [
            "grant_type": grant_type,
            "client_id": client_id,
            "client_secret": client_secret,
            "username": username,
            "password": password
        ]
        
        let t = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "oauth/token",
            method: .post,
            task: .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.httpBody
            ),
            headers: headers,
            authorizationType: .none
        )
        
        return ValueResponseTarget(target: t)
    }
    
    //MARK: - pre validation
    public static func preValidateEmail(email: String, accessToken: String) -> BasicResponseTarget {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        let parameters: [String: Any] = [
            "email": email
        ]
        
        let apiBaseURL: URL = { URL(string: "https://tz.isoko.africa/wit-backend/" )! }()
        
        let t = AnyTarget(
            baseURL: apiBaseURL,
            path: "api/user/pre-validation/email",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            requiresAuth: false,
            authorizationType: .none
        )
        
        return BasicResponseTarget(target: t)
    }
    
    public static func preValidatePhoneNumber(phoneNumber: String, accessToken: String) -> BasicResponseTarget {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let parameters: [String: Any] = [
            "phoneNumber": phoneNumber
        ]
        
        let apiBaseURL: URL = { URL(string: "https://tz.isoko.africa/wit-backend/" )! }()
        
        let t = AnyTarget(
            baseURL: apiBaseURL,
            path: "api/user/pre-validation/phone",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            requiresAuth: false,
            authorizationType: .none
        )
        
        return BasicResponseTarget(target: t)
    }
    
    public static func accountVerificationOTP(type: RegistrationOTPType, contact: String, accessToken: String) -> BasicResponseTarget {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let parameters: [String: Any] = [
            "type": type.rawValue,
            "contact": contact,
            "autoDetectionHash": "defaultSmsHashXYZ"
        ]
        
        let t = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "account-verification/pre-registration",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return BasicResponseTarget(target: t)
    }
}

//MARK: - New Registration
public extension AuthenticationApi {
    /// Register a user (individual or organization)
//    public static func register(request: RegistrationRequest, accessToken: String) {
//    let userDict: [String: Any] = [
//        "userTypeId": 1,
//        "middleName": "Simons",
//        "lastName": "Malacia",
////            "referralCode": "",
//        "locationId": 1,
//        "roleId": 1,
//        "countryId": 1,
//        "phoneNumber": "+254700340678",
//        "firstName": "Gregory",
//        "ageGroupId": 1,
//        "password": "P@ssw0rd!",
//        "email": "user610@example.co",
//        "genderId": 1
//    ]
//
//        let jsonData = try! JSONSerialization.data(withJSONObject: userDict)
//
//        // Upload user with profile image
//        // let profileImage = UIImage(named: "profile.jpg")
//
//        AuthenticationApi.uploadUser(userJSON: jsonData, profileImage: nil) { result in
//            switch result {
//            case .success(let user):
//                print("User created:", user)
//            case .failure(let error):
//                print("Error:", error)
//            }
//        }
//
//    }
    
    //MARK: - pre validation
    static func register(_ request: RegistrationRequest, accessToken: String) -> BasicResponseTarget {
        let userDict: [String: Any] = request.mapToCreateUserRequest().asDictionary
        let userJSON = try? JSONSerialization.data(withJSONObject: userDict)

//        let imageFile = profileImage.flatMap {
//            UploadFile(
//                data: $0.jpegData(compressionQuality: 0.8)!,
//                name: "profileImage",
//                fileName: "profile.jpg",
//                mimeType: "image/jpeg"
//            )
//        }
//        
//        let files = imageFile.map { [$0] } ?? []

        let t = MultipartUploadTarget(
            baseURL: URL(string: "https://api.dev.isoko.africa/")!,
            path: "v1/users",
            jsonPartName: "user",
            jsonData: userJSON,
            files: [],
            requiresAuth: false
        )

        return BasicResponseTarget(target: t.asAnyTarget())
    }

//MARK: - Password Reset
    public static func initiatePasswordReset(type: PasswordResetType, value: String, accessToken: String) -> BasicResponseTarget {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        let parameters: [String: Any] = [
            "\(type.rawValue)": value
        ]
        
        var path: String {
           switch type {
                case .email:
               return "api/password/request/email"
           case .phoneNumber:
               return "api/password/request/reset"
           @unknown default:
               fatalError()
            }
        }
        
        let t = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: path,
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return BasicResponseTarget(target: t)
    }

    public static func passwordReset(type: PasswordResetType, dto: PasswordResetDto, accessToken: String) -> BasicResponseTarget {
        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        let parameters: [String: Any] = dto.asDictionary
        
        let t = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/password/reset",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: JSONEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return BasicResponseTarget(target: t)
    }
}

// MARK: - Authentication API
extension AuthenticationApi {

    /// Upload or update a user with optional profile image
    /// - Parameters:
    ///   - userJSON: JSON data for user object (nil if only uploading image)
    ///   - profileImage: Optional UIImage
    ///   - completion: Returns UserResponse or Error
    static func uploadUser( userJSON: Data?, profileImage: UIImage?, completion: @escaping (Result<UserV1Response, Error>) -> Void) {

        let url = URL(string: "https://api.dev.isoko.africa/v1/users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // 🔹 Boundary for multipart/form-data
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // 🔹 Build multipart body
        var body = Data()

        if let userJSON = userJSON {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"user\"\r\n")
            body.append("Content-Type: application/json\r\n\r\n")
            body.append(userJSON)
            body.append("\r\n")
        }

        if let image = profileImage,
           let imageData = image.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"profileImage\"; filename=\"profile.jpg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
        }

        body.append("--\(boundary)--\r\n")
        request.httpBody = body

        // 🔹 Send request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(OAuthError.emptyResponse))
                return
            }

            // 🔹 Print raw response
            if let string = String(data: data, encoding: .utf8) {
                print("Raw response:", string)
            }

            do {
                let userResponse = try JSONDecoder().decode(UserV1Response.self, from: data)
                completion(.success(userResponse))
            } catch {
                print("Decoding failed:", error)
                completion(.failure(error))
            }
        }.resume()

    }
}

//{"data":null,"status":400,"message":"email already in use","errors":null}
//{"data":null,"status":400,"message":"phone number already in use","errors":null}
//{"id":"14","email":"user60@example.co","firstName":"Gregory","middleName":null,"lastName":"Malacia","phoneNumber":"+254700345678","username":null,"profileImage":null,"gender":{"id":1,"name":"Male"},"ageGroup":{"id":1,"name":"18-34 Years"},"role":{"id":1,"name":"Trader"},"location":{"id":1,"name":"Nairobi"},"country":{"id":1,"name":"Kenya"},"verified":false,"referralCode":"FHKEIZXKBU","status":"Active"}
