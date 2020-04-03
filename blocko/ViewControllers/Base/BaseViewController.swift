import UIKit

class BaseViewController: UIViewController {

    // MARK: - Constants -

    // MARK: - Variables -

    var bottomLayoutConstraintBaseConstant: CGFloat?
    var bottomLayoutConstraint: NSLayoutConstraint? {
        didSet {
            bottomLayoutConstraintBaseConstant = bottomLayoutConstraint?.constant
        }
    }

    var basePresenter: BasePresenterInput? { return nil }

    // MARK: - Initizalition -

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        setupNavigationBar()
        basePresenter?.viewDidLoad()
        view.backgroundColor = .white
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Keyboard -

    func registerNotifications() {
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

        bottomLayoutConstraint?.constant = bottomLayoutConstraintBaseConstant ?? 0.0
        UIView.animate(withDuration: animationDuration) {
            () -> Void in
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Navigation Bar -

    func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: ColorProvider.standardBlueColor),
                                                               for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false

        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Action -

    @objc
    func backButtonPressed() {
        basePresenter?.backPressed()
    }

    // MARK: - Alerts -

    func showStandardAlert(title: String?, message: String?) {
        showStandardAlert(title: title, message: message, action: nil)
    }

    func showStandardAlert(title: String?, message: String?, action: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: R.string.localizable.general_alert_ok(), style: .default, handler: action)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }

}
