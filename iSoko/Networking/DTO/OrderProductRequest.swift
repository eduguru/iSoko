
public struct OrderProductRequest {
    public let productId: Int
    public let quantity: Int
    
    public func toDictionary() -> [String: Any] {
        return [
            "productId": productId,
            "quantity": quantity
        ]
    }
}
