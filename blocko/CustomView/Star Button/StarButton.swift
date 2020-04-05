import UIKit

class StarButton: UIButton {

    // MARK: - Constants -
    private let kStarButtonSize = CGSize(width: 60, height: 60)

    // MARK: - init -
    init() {
        super.init(frame: .zero)

        setImage(R.image.star()?.withRenderingMode(.alwaysTemplate), for: .selected)
        setImage(R.image.starOutline()?.withRenderingMode(.alwaysTemplate), for: .normal)
        tintColor = UIColor.yellow

        setupConstraints()
    }

    private func setupConstraints() {
        snp.remakeConstraints { make in
            make.size.equalTo(kStarButtonSize)
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
