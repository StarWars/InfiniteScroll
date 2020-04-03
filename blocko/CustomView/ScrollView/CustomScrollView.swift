import UIKit

class CustomScrollView: UIView {

    var contentView = UIView()

    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()

    fileprivate var isHorizontal: Bool = false

    fileprivate var topMaskLayer = Factory.createMaskLayer()

    fileprivate var topMaskHeight: CGFloat = 16.0

    fileprivate var showsTopMask = false

    convenience init(showsTopMask: Bool,
                     topMaskHeight: CGFloat = 16.0,
                     isHorizontal: Bool = false) {

        self.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        self.showsTopMask = showsTopMask
        self.topMaskHeight = topMaskHeight
        self.isHorizontal = isHorizontal

        setupView()
        setupConstraints()
    }

    private func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        if showsTopMask {
            layer.mask = topMaskLayer
        }
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            if isHorizontal {
                make.width.height.equalToSuperview()
            } else {
                make.width.equalTo(snp.width)
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        topMaskLayer.frame = bounds
        let gradientPercentage = topMaskHeight / topMaskLayer.frame.size.height
        topMaskLayer.endPoint = CGPoint(x: 0.5, y: gradientPercentage)
    }

    // MARK: - Interface -

    func addContentSubview(view: UIView) {
        contentView.addSubview(view)
    }

}

extension CustomScrollView {

    struct Factory {

        static func createMaskLayer() -> CAGradientLayer {
            let maskLayer = CAGradientLayer()
            maskLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
            maskLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            return maskLayer
        }

    }

}
