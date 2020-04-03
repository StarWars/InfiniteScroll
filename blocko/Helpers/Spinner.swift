//
//  Copyright © 2018 Square, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import CocoaLumberjack
import QuartzCore
import SnapKit
import UIKit

class Spinner: UIView {

    private let spinnerBg: UIView = {
        let view = UIView()

        view.layer.cornerRadius = 10.0
        view.backgroundColor = ColorProvider.black.withAlphaComponent(0.8)

        return view
    }()

    private let imageView = UIImageView(image: R.image.radialProgress())
    private let rotationKey = "SpinnerRotation"

    private var timer: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = nil

        spinnerBg.translatesAutoresizingMaskIntoConstraints = false
        addSubview(spinnerBg)

        NSLayoutConstraint.activate([
            spinnerBg.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 2.0),
            spinnerBg.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2.0),
            spinnerBg.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinnerBg.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        self.alpha = 0

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startSpinning() {
        startTimer()
    }

    func stopSpinning() {
        if let timer = timer, timer.isValid {
            stopTimer()
        } else {
            stopAnimatingSpinning()
        }
    }

    private func startTimer() {
        if let timer = timer {
            timer.invalidate()
        }

        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false) { [weak self] _ in
            self?.animateSpinning()
        }

    }

    private func stopTimer() {
        timer?.invalidate()
    }

    private func animateSpinning() {
        DispatchQueue.main.async {
            guard self.imageView.layer.animation(forKey: self.rotationKey) == nil else {
                DDLogDebug("Already spinning.")
                return
            }

            let spin = CABasicAnimation(keyPath: "transform.rotation")
            spin.fromValue = 0
            spin.toValue = Float.pi * 2
            spin.duration = 1
            spin.repeatCount = .infinity

            self.imageView.layer.add(spin, forKey: self.rotationKey)

            UIView.animate(withDuration: 0.16) {
                self.alpha = 1.0
            }
        }
    }

    private func stopAnimatingSpinning() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.16, animations: {
                self.alpha = 0.0
            }, completion: { _ in
                if self.imageView.layer.animation(forKey: self.rotationKey) != nil {
                    self.imageView.layer.removeAnimation(forKey: self.rotationKey)
                }
            })
        }
    }
}
