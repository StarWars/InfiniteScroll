import UIKit

struct ColorProvider {

    // MARK: - Helpers -

    static func createColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }

    // MARK: - General -

    static var standardBlueColor: UIColor {
        return createColor(red: 67, green: 125, blue: 196, alpha: 1.0)
    }

    static var veryLightBlueColor: UIColor {
        return createColor(red: 248, green: 252, blue: 254, alpha: 1.0)
    }

    static var tabBarBorderColor: UIColor {
        return createColor(red: 212, green: 232, blue: 250, alpha: 1.0)
    }

    static var white: UIColor {
        return UIColor.white
    }

    static var lightColor: UIColor {
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

    static var refreshControl: UIColor {
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // Why not .white? Because I don't know anything about the dark mode.
    }


}
