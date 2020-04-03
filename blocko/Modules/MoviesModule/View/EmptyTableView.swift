import SnapKit
import UIKit

class EmptyTableView: UIView {

    // MARK: - User interaction -

    // MARK: - constants -
    private let kMargin: Double = 16

    // MARK: - ivars -
    private lazy var title: UILabel = {
        let view = UILabel()
        view.font = FontProvider.standardBold
        view.textColor = ColorProvider.black
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()

    public init(title: String?) {
        super.init(frame: .zero)
        backgroundColor = ColorProvider.background
        self.title.text = title
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(title)
    }

    private func setupConstraints() {
        snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(0)
        }

        title.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(kMargin)
            make.centerY.equalToSuperview()
        }
    }
}
