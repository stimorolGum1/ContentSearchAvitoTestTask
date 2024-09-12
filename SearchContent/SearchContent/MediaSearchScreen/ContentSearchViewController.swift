//
//  ContentSearchViewController.swift
//  SearchContent
//
//  Created by Danil on 07.09.2024.
//

import UIKit

final class ContentSearchViewController: UIViewController {
    
    let cellId = "collectionCell"
    var presenter: ContentSearchPresenter!
    var oneTwoColumn = false
    
    private lazy var contentSearchBar: UISearchBar = {
        let search = UISearchBar()
        search.backgroundColor = .white
        search.layer.cornerRadius = 10
        search.layer.borderWidth = 1.0
        search.layer.borderColor = UIColor.gray.cgColor
        search.barTintColor = .clear
        search.searchBarStyle = .minimal
        search.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Поиск...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        search.searchTextField.textColor = .black
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    private lazy var changeCollectionColumnButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "columns"), for: .normal)
        button.addTarget(self, action: #selector(changeCollectionColumn), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var historyTableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "historyCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var contentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let totalPadding = CGFloat(16 * 2 + (2 - 1) * 16)
        let itemWidth = (UIScreen.main.bounds.width - totalPadding) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        historyTableView.delegate = self
        historyTableView.dataSource = self
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        contentCollectionView.register(ContentSearchCell.self, forCellWithReuseIdentifier: cellId)
        contentSearchBar.delegate = self
    }
    
    private func setupViews() {
        view.addSubview(contentSearchBar)
        view.addSubview(historyTableView)
        view.addSubview(changeCollectionColumnButton)
        view.addSubview(contentCollectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            contentSearchBar.trailingAnchor.constraint(equalTo: changeCollectionColumnButton.leadingAnchor, constant: -10),
            contentSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            changeCollectionColumnButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            changeCollectionColumnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            changeCollectionColumnButton.heightAnchor.constraint(equalTo: contentSearchBar.heightAnchor, constant: 0),
            changeCollectionColumnButton.widthAnchor.constraint(equalTo: contentSearchBar.heightAnchor, constant: 0),
            
            contentCollectionView.topAnchor.constraint(equalTo: contentSearchBar.bottomAnchor, constant: 5),
            contentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            contentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            contentCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            historyTableView.topAnchor.constraint(equalTo: contentSearchBar.bottomAnchor),
            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            historyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func changeCollectionColumn() {
        let layout = contentCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        if oneTwoColumn == false {
            let totalPadding = CGFloat(16 * 2 + (2 - 1) * 16)
            let itemWidth = (UIScreen.main.bounds.width - totalPadding)
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            oneTwoColumn = true
        } else {
            let totalPadding = CGFloat(16 * 2 + (2 - 1) * 16)
            let itemWidth = (UIScreen.main.bounds.width - totalPadding) / 2
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            oneTwoColumn = false
        }
    }
    
    func reloadCollection() {
        contentCollectionView.reloadData()
    }
    
    func reloadTableView() {
        historyTableView.reloadData()
    }
    
    func toggleViews(flag: Bool) {
        historyTableView.isHidden = !flag
        contentCollectionView.isHidden = flag
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(
            title: "Произошла Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(
            UIAlertAction(
                title: "Ок",
                style: .default))
        present(alertController, animated: true)
    }
}

extension ContentSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.fetchHistory(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let search = searchBar.text else { return }
        presenter.saveHistory(search)
        presenter.getData(query: search)
        toggleViews(flag: true)
        searchBar.becomeFirstResponder()
        
    }
}

extension ContentSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowInHistoryTableView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        cell.textLabel?.text = presenter.dataAtRowInHistoryTableView(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSearch = presenter.dataAtRowInHistoryTableView(index: indexPath.row)
        contentSearchBar.text = selectedSearch
        searchBarSearchButtonClicked(contentSearchBar)
    }
}

extension ContentSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfRowInContentCollectionView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ContentSearchCell
        cell.contentImageView.loadImage(urlString: presenter.dataAtRowInContentCollectionView(index: indexPath.row).urls.small)
        cell.descriptionLabel.text = presenter.dataAtRowInContentCollectionView(index: indexPath.row).altDescription ?? "no description"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.showDetailScreen(author: presenter.dataAtRowInContentCollectionView(index: indexPath.row).user.name ?? "no author",
                                   description: presenter.dataAtRowInContentCollectionView(index: indexPath.row).altDescription ?? "no description",
                                   imageLink: presenter.dataAtRowInContentCollectionView(index: indexPath.row).urls.regular)
    }
}


