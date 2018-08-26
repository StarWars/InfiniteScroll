import UIKit

protocol CustomTabBarDelegate: class {

    func didChooseTab(index: Int)

}

class CustomTabBar: UIView {

    private let kTabBarHeight: CGFloat = 44.0
    private let kChangeTabDuration = 0.25
    private let kImagesNames =  ["tab-home", "tab-main", "tab-profile"]

    // Currently returning same images because active assets are not available
    private var kActiveImagesNames: [String] {
        return kImagesNames
    }

    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill

        return stackView
    }()

    private let topSeparator = UIView(color: ColorProvider.tabBarBorderColor)

    weak var delegate: CustomTabBarDelegate?

    // MARK: - Initialization -

    convenience init() {
        self.init(frame: .zero)
        setupView()
        setupConstraints()
    }

    private func setupView() {
        addSubview(buttonsStackView)
        addSubview(topSeparator)

        for (index, imageName) in kImagesNames.enumerated() {

            let item = BaseButton(imageName: imageName)
            item.pressedAction = { [weak self] in
                self?.selectTabAtIndex(index: index)
            }

            buttonsStackView.addArrangedSubview(item)
        }

        backgroundColor = ColorProvider.veryLightBlueColor
    }

    private func setupConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(kTabBarHeight)
        }

        buttonsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        topSeparator.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    // MARK: - Action -

    func selectTabAtIndex(index: Int) {
        selectTab(index: index)
        delegate?.didChooseTab(index: index)
    }

    // MARK: - Interaction -

    func selectTab(index: Int) {
        for (viewIndex, view) in buttonsStackView.arrangedSubviews.enumerated() {
            if let button = view as? BaseButton {
                let isSelected = viewIndex == index
                let imageName = isSelected ? kActiveImagesNames[viewIndex] : kImagesNames[viewIndex]
                button.alpha = isSelected ? 1.0 : 0.5
                button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }

}
