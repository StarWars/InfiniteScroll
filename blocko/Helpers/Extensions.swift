import SnapKit
import UIKit

extension UIView {

    convenience init(color: UIColor) {
        self.init()
        backgroundColor = color
    }

    var safeArea: ConstraintBasicAttributesDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        }
        return self.snp
    }

    func roundedEdges(radius: CGFloat = 10) {
        clipsToBounds = true
        layer.cornerRadius = radius
    }

    func createVerticalGradient(from: UIColor, to: UIColor, bounds: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [from.cgColor, to.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        return gradientLayer
    }

}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

extension Double {
    func timestampToString(format: DateFormatString) -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()

        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = format.rawValue

        let strDate = dateFormatter.string(from: date)

        return strDate
    }
}
