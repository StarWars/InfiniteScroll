import UIKit

class BlurredView: BaseView {

    private lazy var blurEffect = UIBlurEffect(style: .dark)
    private lazy var blurView = UIVisualEffectView(effect: blurEffect)

    override func setupSubviews() {
        backgroundColor = .clear
        addSubview(blurView)
    }

    override func setupConstraints() {
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
