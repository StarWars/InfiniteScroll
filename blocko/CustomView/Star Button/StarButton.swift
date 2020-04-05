import UIKit

class StarButton: UIButton {

    // MARK: - Constants -
    private let kStarButtonSize = CGSize(width: 45, height: 45)

    private lazy var blurredBackground: BlurredView = {
        let view = BlurredView()
        view.roundedEdges()
        view.isUserInteractionEnabled = false
        return view
    }()

    // MARK: - init -
    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }

    private func setupView() {
        setImage(R.image.star()?.withRenderingMode(.alwaysTemplate), for: .selected)
        setImage(R.image.starOutline()?.withRenderingMode(.alwaysTemplate), for: .normal)
        tintColor = UIColor.yellow
        addSubview(blurredBackground)

        if let imageView = imageView {
            bringSubviewToFront(imageView)
        }
    }

    private func setupConstraints() {
        snp.remakeConstraints { make in
            make.size.equalTo(kStarButtonSize)
        }
        blurredBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func toggleSelection() {
        self.isSelected = !self.isSelected
    }

    // MARK: - required -
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
