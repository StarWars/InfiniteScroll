import UIKit

class CustomScrollView: UIView {

    var contentView = UIView()

    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()

    convenience init() {

        self.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        setupView()
        setupConstraints()
    }

    private func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(snp.width)
        }
    }

    // MARK: - Interface -
    func addContentSubview(view: UIView) {
        contentView.addSubview(view)
    }

}
