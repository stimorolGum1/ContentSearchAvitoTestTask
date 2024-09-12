//
//  DetailScreenPresenter.swift
//  SearchContent
//
//  Created by Danil on 08.09.2024.
//

import Foundation

final class DetailScreenPresenter {
    
    weak var view: DetailScreenViewController?
    let model: DetailScreenModel
    
    init(view: DetailScreenViewController?, model: DetailScreenModel) {
        self.view = view
        self.model = model
    }
    func fetchImageLink() -> String {
        return model.imageLink
    }
    
    func setData() {
        view?.authorLabel.text = model.author
        view?.descriptionLabel.text = model.description
        view?.mediaImageView.loadImage(urlString: model.imageLink)
    }
    
    func closeDetail() {
        view?.dismiss(animated: true)
    }
}
