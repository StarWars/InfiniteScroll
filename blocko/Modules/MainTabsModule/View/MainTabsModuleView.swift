import SnapKit
import UIKit

class MainTabsModuleView: UIView {

	// MARK: - Constants -

	// MARK: - Variables -

    let tabBar = CustomTabBar()
    let containerView = UIView()

	// MARK: - Initialization -

	public init() {
		super.init(frame: .zero)
		setupSubviews()
		setupConstraints()
	}

	private func setupSubviews() {
        addSubview(tabBar)
        addSubview(containerView)
	}

	private func setupConstraints() {
        tabBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(safeArea.bottom)
        }

        containerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(tabBar.snp.top)
        }
	}

	// MARK: - Required Init -

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
