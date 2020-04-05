import SnapKit
import UIKit

class EmptyTableView: UIView {

    // MARK: - constants -
    private let kMargin: Double = 16

    // MARK: - ivars -
    private lazy var title: UILabel = {
        let view = UILabel()
        view.font = FontProvider.standardBold
        view.textColor = ColorProvider.white
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()

    public init(title: String?) {
        super.init(frame: .zero)
        backgroundColor = UIColor.clear
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
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.height)
        }

        title.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(kMargin)
            make.center.equalToSuperview()
        }
    }
}
