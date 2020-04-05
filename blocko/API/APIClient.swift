import Alamofire
import CocoaLumberjack
import Foundation

enum APIEndpoints: String {

    case createAccount = "account"
}

class APIClient: NSObject, BaseInteractorProtocol {

    // MARK: - Constants -
    private let kServerInformationFileName = "ServerInformation"
    private var kAPIToken: String?

    // MARK: - Variables -
    var baseURL: String?
    var baseImagesURL: String?

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

        guard let path = Bundle.main.path(forResource: kServerInformationFileName, ofType: "plist") else {
            DDLogError("Failed to find base server information file")
            return
        }

        guard let serverData = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
            DDLogError("Failed to parse '\(kServerInformationFileName).plist' file")
            return
        }

        if let currentEnv = serverData["currentEnv"] as? String {
            baseURL = serverData[currentEnv]?["baseAPIURL"] as? String
            baseImagesURL = serverData[currentEnv]?["imagesURL"] as? String
        }

        if let apiKey = serverData["api_key"] as? String {
            kAPIToken = apiKey
        }

    }

    internal func sendRequest(request: BaseRequest) -> Request? {

        guard var fullURL = baseURL, let requestURL = request.url, let apiToken = kAPIToken else {
            request.failureResponseHandler?(nil, .unknown)
            return nil
        }

        fullURL.append(requestURL)

        var headers = HTTPHeaders()

        headers.add(HTTPHeader(name: "Accept", value: "application/json"))
        headers.add(HTTPHeader(name: "Content-Type", value: "application/json; charset=utf-8"))
        headers.add(HTTPHeader(name: "Authorization", value: "Bearer \(apiToken)"))

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

    func backgroundImageURL(_ movie: Movie?) -> URL? {
        guard let baseImagesURL = baseImagesURL, let movie = movie else {
            return nil
        }

        guard let backgroundPath = movie.backdropPath?.dropFirst() else {
            DDLogVerbose("Empty background path")
            return nil
        }

        let imageURL = "\(baseImagesURL)\(backgroundPath)"
        return URL(string: imageURL)
    }

}
