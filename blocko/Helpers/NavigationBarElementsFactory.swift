import UIKit

public struct NavigationBarElementsFactory {

    static func backButton() -> UIBarButtonItem {
        let backButton = UIBarButtonItem()
        backButton.image = R.image.back_btn()?.withRenderingMode(.alwaysTemplate)
        backButton.tintColor = ColorProvider.white
        backButton.style = .done
        return backButton
    }

    static func xButton() -> UIBarButtonItem {
        let xButton = UIBarButtonItem()
        xButton.tintColor = ColorProvider.white
        xButton.image = R.image.close()
        return xButton
    }

}
