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

    var actionHandler: ((Movie?) -> Void)?

    private var currentMovie: Movie?
    private lazy var movieView = MovieCellView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
        setupActions()
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

    private func setupActions() {
        movieView.favButton.addTarget(self, action: #selector(favButtonPressed), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func favButtonPressed() {
        actionHandler?(currentMovie)
    }

}

extension MovieCell: MovieConfiguration {
    func setup(with movie: Movie?) {
        currentMovie = movie
        movieView.setup(with: movie)
    }
}
