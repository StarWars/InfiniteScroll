import Foundation

enum APIErrorCode: Int {
    case noInternet = -1,
    unknown = -2,
    allGood = 200,
    unauthorized = 401

    var description: String {
        switch self {
        case .unknown:
            return R.string.localizable.unknown_reason()
        case .unauthorized:
            return R.string.localizable.unauthorized_api_access()
        case .noInternet:
            return R.string.localizable.no_internet_connection()
        case .allGood:
            return R.string.localizable.no_error()
        }
    }
}
