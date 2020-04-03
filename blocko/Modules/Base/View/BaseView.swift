import UIKit

class BaseView: UIView {

    // MARK: - Constants -
    var bottomLayoutConstraint: NSLayoutConstraint?
    internal let kButtonRadius: CGFloat = 10
    internal let kButtonHeight: CGFloat = 45

    // Constants
    let kTextFieldHeight = 60
    let kGeneralOffset = 16
    let kFieldsVerticalOffset = 8

    // Init

    public init() {
        super.init(frame: .zero)
        backgroundColor = ColorProvider.white
        loadView()
    }

    @objc
    internal func setupConstraints() {
        fatalError("Didn't implement setupConstraints method")
    }

    @objc
    internal func setupSubviews() {
        fatalError("Didn't implement setupView method")
    }

    @objc
    internal func loadView() {
        setupSubviews()
        setupConstraints()
    }

    @objc
    func injected() {
        loadView()
    }

    // MARK: - Required Init -

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
