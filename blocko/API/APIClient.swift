import Alamofire
import CocoaLumberjack
import Foundation

enum APIEndpoints: String {

    case createAccount = "account"
}

class APIClient: NSObject, BaseInteractorProtocol {

    // MARK: - Constants -

    private let kServerInformationFileName = "ServerInformation"
    private let kAPIToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYWIyM2FmMWU3Y2IwYzg4MjdmYWY5MzUyZGExYWRiYyIsInN1YiI6IjU1YzkwZWZkOTI1MTQxNzdjYzAwMDRmMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.VAIV1oAxMZUrd9VcLb2qICrRhHjrpBqjlH8FMcsn_y0"

    // MARK: - Variables -
    var baseURL: String?

    private var alamofireManager: Alamofire.Session?
    static let sharedInstance = APIClient()

    // MARK: - Initialization -

    override init() {
        super.init()

        setupBasicServerInformations()

        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 30
        let alamofireManager = Alamofire.Session(configuration: configuration)

        self.alamofireManager = alamofireManager
    }

    private func setupBasicServerInformations() {
        if let path = Bundle.main.path(forResource: kServerInformationFileName, ofType: "plist") {
            if let serverData = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                if let currentEnv = serverData["currentEnv"] as? String {
                    baseURL = serverData[currentEnv]?["baseAPIURL"] as? String
                }
            }
        } else {
            DDLogError("Failed to find base server information file")
        }
    }

    internal func sendRequest(request: BaseRequest) -> Request? {

        guard var fullURL = baseURL, let requestURL = request.url else {
            request.failureResponseHandler?(nil, .unknown)
            return nil
        }

        fullURL.append(requestURL)

        var headers = HTTPHeaders()

        headers.add(HTTPHeader(name: "Accept", value: "application/json"))
        headers.add(HTTPHeader(name: "Content-Type", value: "application/json; charset=utf-8"))
        headers.add(HTTPHeader(name: "Authorization", value: "Bearer \(kAPIToken)"))

        if Connectivity.sharedInstance.isInternetAvailable {

            var newParams = [String: Any]()
            if let requestParams = request.bodyParams {
                for (key, value) in requestParams {
                    newParams[key] = value
                }
            }

            let req: Request? = self.alamofireManager?.request(fullURL, method: request.method,
                                                               parameters: newParams,
                                                               encoding: request.parametersEncoding,
                                                               headers: headers).responseData { response in

                                                                self.handleResponse(response, withRequest: request)

            }

            return req

        } else {
            request.failureResponseHandler?(nil, APIErrorCode.noInternet)
            return nil
        }
    }

}
