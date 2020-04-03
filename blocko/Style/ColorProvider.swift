import UIKit

struct ColorProvider {

    // MARK: - Helpers -

    static func createColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }

    // MARK: - General -

    static var white: UIColor {
        return UIColor.white
    }

    static var primaryColor: UIColor {
        return UIColor.red
    }

    static var black: UIColor {
        return UIColor.black
    }
    
    static var shadow: UIColor {
        return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    }

    static var title: UIColor {
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

    static var subtitle: UIColor {
        return ColorProvider.title.withAlphaComponent(0.8)
    }

    static var background: UIColor {
        return UIColor(red: 0.26, green: 0.31, blue: 0.35, alpha: 1.00)
    }

    static var refreshControl: UIColor {
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // Why not .white? Because I don't know anything about the dark mode.
    }


}
