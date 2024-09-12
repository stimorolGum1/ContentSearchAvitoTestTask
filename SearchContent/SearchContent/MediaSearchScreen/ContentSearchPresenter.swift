//
//  ContentSearchPresenter.swift
//  SearchContent
//
//  Created by Danil on 08.09.2024.
//

import Foundation

final class ContentSearchPresenter {
    
    weak var view: ContentSearchViewController?
    var model: ContentSearchModel
    let net: NetworkManager
    let builder: Builder
    let jsonDecoder = JSONDecoder()
    
    init(view: ContentSearchViewController?, model: ContentSearchModel, net: NetworkManager, builder: Builder) {
        self.view = view
        self.model = model
        self.net = net
        self.builder = builder
    }
    
    func getData(query: String) {
        net.fetchData(query: query, page: 1) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let jsonData = try self?.jsonDecoder.decode(UnsplashSearchResponse.self, from: data)
                    self?.model.items = jsonData?.results ?? []
                    self?.view?.reloadCollection()
                    self?.view?.toggleViews(flag: false)
                } catch {
                    fatalError()
                }
            case .failure(let error):
                self?.view?.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    func numberOfRowInContentCollectionView() -> Int {
        return model.items.count
    }
    
    func dataAtRowInContentCollectionView(index: Int) -> Photo  {
        return model.items[index]
    }
    
    func numberOfRowInHistoryTableView() -> Int {
        return model.filteredHistory.count
    }
    
    func dataAtRowInHistoryTableView(index: Int) -> String {
        return model.filteredHistory[index]
    }
    
    func saveHistory(_ query: String) {
        var history = getHistory()
        if history.contains(query) { return }
        
        if history.count >= 5 {
            history.removeLast()
        }
        history.insert(query, at: 0)
        UserDefaults.standard.set(history, forKey: "searchHistory")
    }
    
    private func getHistory() -> [String] {
        return UserDefaults.standard.stringArray(forKey: "searchHistory") ?? []
    }
    
    func fetchHistory(searchText: String) {
        let history = getHistory()
        model.filteredHistory = history.filter { $0.lowercased().contains(searchText.lowercased()) }
        if model.filteredHistory.isEmpty {
            view?.toggleViews(flag: false)
        } else {
            view?.toggleViews(flag: true)
        }
        view?.reloadTableView()
    }
    
    func showDetailScreen(author: String,
                          description: String,
                          imageLink: String) {
        let vc = builder.makeDetailScreen(author: author, description: description, imageLink: imageLink)
        vc.modalPresentationStyle = .fullScreen
        view?.present(vc, animated: true)
    }
}
