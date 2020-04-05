import CocoaLumberjack
import NotificationBannerSwift
import RxSwift
import SnapKit
import UIKit

protocol BaseModuleViewInput: BaseViewInput {
    func hideBanner()
    func showError(_ error: NSError)
    func reloadData()

    var basePresenter: BasePresenterInput? { get }
}

class BaseViewController: UIViewController {

    var disposeBag = DisposeBag()

    var basePresenter: BasePresenterInput?

    // MARK: - init -
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    init(presenter: BasePresenterInput) {
        self.basePresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Constants -

    private let kBarButtonsOffset: CGFloat = -14.0

    // MARK: - Variables -
    private var typeaheadLayoutConstraintBaseConstant: CGFloat?
    var typeaheadBottomLayoutConstraint: NSLayoutConstraint? {
        didSet {
            typeaheadLayoutConstraintBaseConstant = typeaheadBottomLayoutConstraint?.constant
        }
    }
    private var bottomLayoutConstraintBaseConstant: CGFloat?
    var bottomLayoutConstraint: NSLayoutConstraint? {
        didSet {
            bottomLayoutConstraintBaseConstant = bottomLayoutConstraint?.constant
        }
    }

    /// Used to show error messages
    fileprivate var infoBanner: GrowingNotificationBanner?

    // MARK: - Initizalition -

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        setupNavigationBar()
        basePresenter?.viewDidLoad()
        view.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        basePresenter?.viewWillAppear()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Keyboard -

    func registerKeyboardAvoiding() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo

        guard let keyboardFrameValue = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let animationDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
                return
        }

        let keyboardFrame: CGRect = keyboardFrameValue.cgRectValue

        typeaheadBottomLayoutConstraint?.constant = -keyboardFrame.height
        bottomLayoutConstraint?.constant = -keyboardFrame.height
        UIView.animate(withDuration: animationDuration) {
            () -> Void in
            self.view.layoutIfNeeded()
        }
    }

    @objc
    func keyboardWillHide(notification: NSNotification) {
        let userInfo = notification.userInfo

        guard let animationDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }

        typeaheadBottomLayoutConstraint?.constant = typeaheadLayoutConstraintBaseConstant ?? 0.0
        bottomLayoutConstraint?.constant = bottomLayoutConstraintBaseConstant ?? 0.0
        UIView.animate(withDuration: animationDuration) {
            () -> Void in
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Navigation Bar -

    func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: ColorProvider.primaryColor),
                                                               for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false

        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ColorProvider.white]
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func createBackButtonWithImage() {
        let backButton = NavigationBarElementsFactory.backButton()

        backButton.action = #selector(backButtonPressed)
        backButton.target = self
        adjustBarButtonVerticalAlignment(button: backButton)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.hidesBackButton = true

    }

    func createXButton() {
        let xButton = NavigationBarElementsFactory.xButton()

        xButton.action = #selector(xButtonSelected)
        xButton.target = self
        adjustBarButtonVerticalAlignment(button: xButton)

        navigationItem.leftBarButtonItem = xButton
    }

    private func adjustBarButtonVerticalAlignment(button: UIBarButtonItem) {
        if #available(iOS 11.0, *) {
        } else {
            button.setBackgroundVerticalPositionAdjustment(kBarButtonsOffset, for: .default)
            let offset = UIOffset(horizontal: 0, vertical: -kBarButtonsOffset)
            button.setTitlePositionAdjustment(offset, for: .defaultPrompt)
        }
    }

    func hideBackButton() {
        navigationItem.hidesBackButton = true
    }

    // MARK: - Action -

    @objc
    func backButtonPressed() {
        basePresenter?.backPressed()
    }

    @objc
    func xButtonSelected() {}

    // MARK: - Alerts -

    func showStandardAlert(title: String?, message: String?, action: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: R.string.localizable.general_alert_ok(), style: .default, handler: action)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }

}

extension BaseViewController: BaseModuleViewInput {

    @objc
    func reloadData() {
        preconditionFailure("This method must be overridden")
    }

    func showError(_ error: NSError) {

        infoBanner?.dismiss()

        if let description = error.userInfo["localizedDescription"] as? String {

            infoBanner = GrowingNotificationBanner(title: R.string.localizable.error_failure(),
                                                   subtitle: description,
                                                   style: BannerStyle.danger)
        } else {

            infoBanner = GrowingNotificationBanner(title: R.string.localizable.error_failure(),
                                                   subtitle: error.localizedDescription,
                                                   style: BannerStyle.danger)
        }

        NotificationBannerQueue.default.removeAll()

        infoBanner?.show(bannerPosition: .top, on: self)

    }

    func hideBanner() {
        NotificationBannerQueue.default.removeAll()
    }

    func showBanner(message: String, style: BannerStyle = BannerStyle.success) {

        infoBanner?.dismiss()

        var bannerTitle = R.string.localizable.info_banner_title_success()
        let bannerDuration = 8.0

        switch style {
        case .danger:
            bannerTitle = R.string.localizable.info_banner_title_failure()
        case .warning:
            bannerTitle = R.string.localizable.info_banner_title_warning()
        default:
            break
        }

        infoBanner = GrowingNotificationBanner(title: bannerTitle,
                                               subtitle: message,
                                               style: style)

        infoBanner?.duration = bannerDuration

        NotificationBannerQueue.default.removeAll()

        infoBanner?.show()

    }

}
