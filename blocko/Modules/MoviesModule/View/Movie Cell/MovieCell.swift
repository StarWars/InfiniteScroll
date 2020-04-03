//
//  TipCell.swift
//  brgrtip
//
//  Created by Michal Stawarz on 11/10/2019.
//  Copyright © 2019 LE34. All rights reserved.
//

import Reusable
import SnapKit
import UIKit


protocol MovieConfiguration {
    func setup(with movie: Movie?)
}

class MovieCell: UITableViewCell, Reusable {

    private lazy var movieView = MovieCellView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }

    private func setupView() {
        tintColor = ColorProvider.white
        selectionStyle = .none
        contentView.addSubview(movieView)
        backgroundColor = UIColor.clear
    }

    private func setupConstraints() {

        movieView.setContentCompressionResistancePriority(.required, for: .vertical)
        movieView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension MovieCell: MovieConfiguration {
    func setup(with movie: Movie?) {
        movieView.setup(with: movie)
    }
}
