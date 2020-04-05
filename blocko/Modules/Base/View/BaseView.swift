import UIKit

class BaseView: UIView {

    // MARK: - Constants -
    var bottomLayoutConstraint: NSLayoutConstraint?

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

    // MARK: - Required Init -

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
