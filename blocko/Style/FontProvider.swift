import UIKit

struct FontProvider {

    static var standard: UIFont {
        return UIFont.systemFont(ofSize: 12, weight: .regular)
    }

    static var standardBold: UIFont {
        return UIFont.systemFont(ofSize: 12, weight: .bold)
    }

}
