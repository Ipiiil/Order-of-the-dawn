//
//  QuoteViewController.swift
//  CatGallery
//
//  Created by Полина Терехина on 20.02.2026.
//

import UIKit

class QuoteViewController: UIViewController {
    
    private var quotes: [Quote] = []
    
    // UI Elements
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .systemPurple
        return indicator
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 140)
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .systemBackground
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "QuoteCell")
        cv.dataSource = self
        cv.delegate = self
        cv.alpha = 0
        return cv
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Не удалось загрузить пророчества"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchQuotes()
    }
    
    //Setup
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "Пророчества"
        
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise"),
            style: .plain,
            target: self,
            action: #selector(refreshQuotes)
        )
        navigationItem.rightBarButtonItem?.tintColor = .systemPurple
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    // API
    private func fetchQuotes() {
        activityIndicator.startAnimating()
        
        let apiKey = "tvBIk4c7J6IkWg43DXgTXTDLAKTycbZhJRiCXl4j"
        
        let categories = ["happiness", "success", "wisdom", "life", "love", "motivation"]
        let randomCategory = categories.randomElement() ?? "happiness"
        let urlString = "https://api.api-ninjas.com/v2/quotes?category=\(randomCategory)&limit=10"
        
        guard let url = URL(string: urlString) else {
            showError()
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            
            if let error = error {
                print("Ошибка сети: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showError()
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.showError()
                }
                return
            }
            
            do {
                let allQuotes = try JSONDecoder().decode([Quote].self, from: data)
                
                let shuffleQuotes = allQuotes.shuffled()
                let randomQuotes = Array(shuffleQuotes.prefix(3))
                
                DispatchQueue.main.async {
                    self.quotes = randomQuotes
                    self.collectionView.reloadData()
                    self.errorLabel.isHidden = true
                    
                    UIView.animate(withDuration: 0.3) {
                        self.collectionView.alpha = 1
                    }
                }
            } catch {
                print("Ошибка парсинга: \(error)")
                DispatchQueue.main.async {
                    self.showError()
                }
            }
        }
        
        task.resume()
    }
    
    private func showError() {
        errorLabel.isHidden = false
        collectionView.alpha = 0
    }
    @objc private func refreshQuotes(){
        fetchQuotes()
    }
}


extension QuoteViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuoteCell", for: indexPath)
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let quote = quotes[indexPath.row]
        
        let cardView = UIView()
        cardView.backgroundColor = .systemPurple.withAlphaComponent(0.1)
        cardView.layer.cornerRadius = 16
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.systemPurple.withAlphaComponent(0.3).cgColor
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(cardView)
        
        // Цитата
        let contentLabel = UILabel()
        contentLabel.text = "“\(quote.quote)”"
        contentLabel.font = .systemFont(ofSize: 16, weight: .medium)
        contentLabel.textColor = .label
        contentLabel.numberOfLines = 4
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(contentLabel)
        
        // Автор
        let authorLabel = UILabel()
        authorLabel.text = "— \(quote.author)"
        authorLabel.font = .systemFont(ofSize: 14, weight: .regular)
        authorLabel.textColor = .systemPurple
        authorLabel.textAlignment = .right
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(authorLabel)
        
        // Алмазик за прочтение
        let crystalImageView = UIImageView()
        crystalImageView.image = UIImage(systemName: "sparkles")
        crystalImageView.tintColor = .systemPurple
        crystalImageView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(crystalImageView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            
            crystalImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            crystalImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            crystalImageView.widthAnchor.constraint(equalToConstant: 20),
            crystalImageView.heightAnchor.constraint(equalToConstant: 20),
            
            contentLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            contentLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            authorLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 12),
            authorLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            authorLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
        
        return cell
    }
}

// UICollectionViewDelegate
extension QuoteViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let quote = quotes[indexPath.row]
        
        let alert = UIAlertController(
            title: "Пророчество",
            message: "Запомни эти слова:\n\n“\(quote.quote)”\n\n— \(quote.author)",
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: "Поделиться", style: .default) { _ in
                let textToShare = "“\(quote.quote)” — \(quote.author)"
                let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
                self.present(activityVC, animated: true)
            })
            
            alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
            
            present(alert, animated: true)
    }
}
