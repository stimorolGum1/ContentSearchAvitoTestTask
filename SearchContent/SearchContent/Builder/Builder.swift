//
//  Builder.swift
//  SearchContent
//
//  Created by Danil on 08.09.2024.
//

import Foundation
import UIKit

class Builder {
    func makeMediaSearchScreen() -> UIViewController {
        let model = ContentSearchModel()
        let net = NetworkManager()
        let view = ContentSearchViewController()
        let presenter = ContentSearchPresenter(view: view,
                                             model: model,
                                               net: net,
                                               builder: self)
        view.presenter = presenter
        return view
    }
    
    func makeDetailScreen(author: String,
                          description: String,
                          imageLink: String) -> UIViewController {
        let model = DetailScreenModel(author: author,
                                      description: description,
                                      imageLink: imageLink)
        let view = DetailScreenViewController()
        let presenter = DetailScreenPresenter(view: view,
                                             model: model)
        view.presenter = presenter
        return view
    }
}
