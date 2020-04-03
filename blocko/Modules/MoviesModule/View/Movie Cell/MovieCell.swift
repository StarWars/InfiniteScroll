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


protocol MovieCellConfiguration {
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
        accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        selectionStyle = .none
        contentView.backgroundColor = ColorProvider.white
        contentView.addSubview(movieView)
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

extension MovieCell: MovieCellConfiguration {
    func setup(with movie: Movie?) {
        movieView.setup(with: movie)
    }
}
