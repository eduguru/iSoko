//
//  ProductsApi.swift
//  
//
//  Created by Edwin Weru on 28/08/2025.
//

import Foundation
import Moya
import NetworkingKit

public struct ProductsApi {
    
    //MARK: - products lisitings
    public static func getAllProducts(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[ProductResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/product",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getFeaturedProducts(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[ProductResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count, "isFeatured": "active"]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/product",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getProductsByCategory(page: Int, count: Int, categoryId: String, accessToken: String) -> OptionalObjectResponseTarget<[ProductResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count, "categoryId": categoryId]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/product",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getProductsByCurrentUser(page: Int, count: Int, accessToken: String) -> OptionalObjectResponseTarget<[ProductResponse]> {
        let parameters: [String: Any] = ["page": page, "count": count]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/product/current-user",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getProductDetails(page: Int, count: Int, productId: String, accessToken: String) -> OptionalObjectResponseTarget<ProductResponse> {
        let parameters: [String: Any] = ["page": page, "count": count]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/product/product-details/\(productId)",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func getProductOwnerDetails(page: Int, count: Int, productId: String, accessToken: String) -> OptionalObjectResponseTarget<ProductOwnerResponse> {
        let parameters: [String: Any] = ["page": page, "count": count]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/product/product-trader-details/\(productId)",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }

    //MARK: - trader products
    public static func createProduct(product: CreateProductDto, accessToken: String) -> OptionalObjectResponseTarget<ProductOwnerResponse> {
        let parameters: [String: Any] = [:]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/product",
            method: .post,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func updateProduct(productId: String, product: UpdateProductDto, accessToken: String) -> OptionalObjectResponseTarget<ProductOwnerResponse> {
        let parameters: [String: Any] = product.asDictionary

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/product/edit/\(productId)",
            method: .get,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func addProductImages(uploadFile: [UploadFile], productId: String, accessToken: String) -> OptionalObjectResponseTarget<ProductOwnerResponse> {
        let parameters: [String: Any] = [:]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/product/image/add/\(productId)",
            method: .put,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func removeProductImage(imageId: String, accessToken: String) -> OptionalObjectResponseTarget<ProductOwnerResponse> {
        let parameters: [String: Any] = [:]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/product/image/remove/\(imageId)",
            method: .put,
            task: .requestPlain,
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func setProductPrimaryImage(imageId: String, accessToken: String) -> OptionalObjectResponseTarget<ProductOwnerResponse> {
        let parameters: [String: Any] = [:]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/product/image/set-primary/\(imageId)",
            method: .put,
            task: .requestPlain,
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
    
    public static func updateProductStatus(status: String, productId: String, accessToken: String) -> OptionalObjectResponseTarget<ProductOwnerResponse> {
        let parameters: [String: Any] = ["status": status]

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let target = AnyTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/product/update-status/\(status)/\(productId)",
            method: .put,
            task: .requestParameters(parameters: parameters, encoding: URLEncoding.default),
            headers: headers,
            authorizationType: .bearer
        )
        
        return OptionalObjectResponseTarget(target: target)
    }
}


public enum UserAPI {
    public static func updateUserProfileImage(image: Data, accessToken: String) -> BasicUploadResponseTarget {
        let headers = ["Authorization": "Bearer \(accessToken)"]

        let file = UploadFile(
            data: image,
            name: "image",
            fileName: "profile.jpg",
            mimeType: "image/jpeg"
        )

        let target = UploadTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/user/update-profile-image",
            files: [file],
            headers: headers,
            authorizationType: .bearer
        )

        return BasicUploadResponseTarget(target: target)
    }
}

public enum GalleryAPI {
    public static func uploadGallery(images: [Data], caption: String, accessToken: String) -> BasicUploadResponseTarget {
        let headers = ["Authorization": "Bearer \(accessToken)"]

        let files = images.enumerated().map { index, image in
            UploadFile(
                data: image,
                name: "photos[]",
                fileName: "photo\(index + 1).jpg",
                mimeType: "image/jpeg"
            )
        }

        let target = UploadTarget(
            baseURL: ApiEnvironment.baseURL,
            path: "api/gallery/upload",
            files: files,
            additionalParams: ["caption": caption],
            headers: headers,
            authorizationType: .bearer
        )

        return BasicUploadResponseTarget(target: target)
    }
}
