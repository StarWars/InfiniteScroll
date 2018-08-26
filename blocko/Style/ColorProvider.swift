import UIKit

class ColorProvider: NSObject {

    // MARK: - Helpers -

    class func createColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }

    // MARK: - General -

    class var standardBlueColor: UIColor {
        return createColor(red: 67, green: 125, blue: 196, alpha: 1.0)
    }

    class var veryLightBlueColor: UIColor {
        return createColor(red: 248, green: 252, blue: 254, alpha: 1.0)
    }

    class var tabBarBorderColor: UIColor {
        return createColor(red: 212, green: 232, blue: 250, alpha: 1.0)
    }

}
