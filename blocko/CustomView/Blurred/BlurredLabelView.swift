import UIKit

class BlurredLabelView: BaseView {

    private let kHorizontalInset: CGFloat = 13
    private let kVerticalInset: CGFloat = 13

    private lazy var blurredView: BlurredView = {
        let view = BlurredView()
        view.roundedEdges()
        return view
    }()

    private lazy var label: UILabel = {
        let view = UILabel()
        view.textColor = ColorProvider.title
        view.font = UIFont.systemFont(ofSize: 12)
        return view
    }()

    override func setupSubviews() {
        backgroundColor = .clear
        addSubview(blurredView)
        addSubview(label)
    }

    override func setupConstraints() {

        blurredView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(kHorizontalInset)
            make.top.bottom.equalToSuperview().inset(kHorizontalInset)
        }
    }

    func setup(title: String) {
        label.text = title
    }

}
