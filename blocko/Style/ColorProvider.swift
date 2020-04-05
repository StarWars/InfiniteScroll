import UIKit

struct ColorProvider {

    // MARK: - General -
    static var white: UIColor {
        return UIColor.white
    }

    static var black: UIColor {
        return UIColor.black
    }

    static var primaryColor: UIColor {
        return UIColor.black
    }

    static var shadow: UIColor {
        return UIColor.black
    }

    static var subtitle: UIColor {
        return ColorProvider.white.withAlphaComponent(0.8)
    }

    static var background: UIColor {
        return UIColor(red: 0.26, green: 0.31, blue: 0.35, alpha: 1.00)
    }

}
