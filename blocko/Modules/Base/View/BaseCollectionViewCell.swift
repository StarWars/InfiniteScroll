import UIKit

class BaseCollectionViewCell: UICollectionViewCell {

    class var reuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {

    }

    func setupConstraints() {

    }

}
