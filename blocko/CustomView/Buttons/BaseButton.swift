import UIKit

class BaseButton: UIButton {

    var pressedAction: (() -> Void)?
    var hasIncreasedTouchArea = false

    var additionalHorizontalPadding: CGFloat = 20.0
    var additionalVerticalPadding: CGFloat = 30.0

    convenience init(imageName: String) {
        self.init(type: .custom)
        setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        setupButton()
    }

    func setupButton() {
        addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }

    @objc
    private func buttonPressed() {
        pressedAction?()
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if hasIncreasedTouchArea {

            let newBound = CGRect(
                x: self.bounds.origin.x - additionalHorizontalPadding,
                y: self.bounds.origin.y - additionalVerticalPadding,
                width: self.bounds.width + 2 * additionalHorizontalPadding,
                height: self.bounds.height + 2 * additionalVerticalPadding
            )
            return newBound.contains(point)

        } else {
            return super.point(inside: point, with: event)
        }

    }

}
