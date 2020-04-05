import UIKit

class StarButton: UIButton {

    // MARK: - Constants -
    private let kStarButtonSize = CGSize(width: 60, height: 60)

    // MARK: - init -
    override init(frame: CGRect) {
        super.init(frame: .zero)

        setImage(R.image.star()?.withRenderingMode(.alwaysTemplate), for: .selected)
        setImage(R.image.starOutline()?.withRenderingMode(.alwaysTemplate), for: .normal)
        tintColor = UIColor.yellow

        setupConstraints()
    }

    private func setupConstraints() {
        snp.makeConstraints { make in
            make.size.equalTo(kStarButtonSize)
        }
    }

    // MARK: - required -
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
