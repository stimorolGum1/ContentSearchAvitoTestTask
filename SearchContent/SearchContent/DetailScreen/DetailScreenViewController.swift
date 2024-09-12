//
//  DetailScreenViewController.swift
//  SearchContent
//
//  Created by Danil on 08.09.2024.
//

import UIKit

final class DetailScreenViewController: UIViewController {
    
    var presenter: DetailScreenPresenter!
    
    private lazy var header: UIView = {
        let header = UIView()
        header.backgroundColor = .black
        header.alpha = 0.5
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = label.font.withSize(15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "Author"
        label.font = label.font.withSize(25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mediaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "photo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var footer: UIView = {
        let footer = UIView()
        footer.backgroundColor = .black
        footer.alpha = 0.5
        footer.translatesAutoresizingMaskIntoConstraints = false
        return footer
    }()

    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "download"), for: .normal)
        button.addTarget(self, action: #selector(downloadImage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "share"), for: .normal)
        button.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        setupViews()
        setupConstraints()
        presenter?.setData()
    }
    
    private func setupViews() {
        view.addSubview(header)
        header.addSubview(backButton)
        header.addSubview(authorLabel)
        header.addSubview(descriptionLabel)
        view.addSubview(mediaImageView)
        view.addSubview(footer)
        footer.addSubview(downloadButton)
        footer.addSubview(shareButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            header.heightAnchor.constraint(equalToConstant: 170),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            backButton.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            
            authorLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor, constant: 0),
            authorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            authorLabel.heightAnchor.constraint(equalToConstant: 30),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor, constant: 0),
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -15),
            descriptionLabel.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -5),
            
            mediaImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            mediaImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            mediaImageView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 0),
            mediaImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mediaImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mediaImageView.bottomAnchor.constraint(equalTo: footer.topAnchor, constant: 0),
            
            footer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            footer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            footer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            footer.heightAnchor.constraint(equalToConstant: 150),
            
            downloadButton.topAnchor.constraint(equalTo: footer.topAnchor, constant: 30),
            downloadButton.trailingAnchor.constraint(equalTo: footer.trailingAnchor, constant: -30),
            downloadButton.heightAnchor.constraint(equalToConstant: 30),
            downloadButton.widthAnchor.constraint(equalToConstant: 30),
            
            shareButton.topAnchor.constraint(equalTo: footer.topAnchor, constant: 30),
            shareButton.leadingAnchor.constraint(equalTo: footer.leadingAnchor, constant: 30),
            shareButton.heightAnchor.constraint(equalToConstant: 30),
            shareButton.widthAnchor.constraint(equalToConstant: 30),
            
            
        ])
    }
    
    @objc private func shareImage() {
        shareLink(viewController: self)
    }
    
    @objc private func downloadImage() {
        saveImageToPhoto(from: mediaImageView)
    }
    
    private func shareLink(viewController: UIViewController) {
        guard let url = URL(string: presenter.fetchImageLink()) else {
            showAlert(message: "Неверный URL")
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    private func saveImageToPhoto(from imageView: UIImageView) {
        guard let image = imageView.image else {
            showAlert(message: "Изображение отсутсвует")
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc private func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {

            showAlert(message: "Ошибка сохранения: \(error.localizedDescription)")
        } else {
            showAlert(message: "Успешно")
        }
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(
            title: message,
            message: nil,
            preferredStyle: .actionSheet
        )
        alertController.addAction(
            UIAlertAction(
                title: "Ок",
                style: .default
            )
        )
        present(alertController, animated: true)
    }
    
    @objc private func close() {
        presenter.closeDetail()
    }
}
