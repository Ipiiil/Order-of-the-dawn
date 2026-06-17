//
//  ShopViewController.swift
//  CatGallery
//
//  Created by Полина Терехина on 20.02.2026.
//

import UIKit
import SwiftUI

class ShopViewController: UIViewController {
    
    // MARK: - Data
    private let items = ShopItem.mockItems
    
    private lazy var itemsByCategory: [ShopItem.Category: [ShopItem]] = {
        Dictionary(grouping: items, by: { $0.category })
    }()
    
    private let purchasedKey = "purchasedBackgroungs"
    private let selectedBackgroundKey = "selectedBackground"
    
    //private lazy var recommendedItems = Array(items.prefix(3))
    
    // MARK: - UI Elements
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPurple.withAlphaComponent(0.1)
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemPurple.withAlphaComponent(0.3).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let diamondImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "sparkles")
        imageView.tintColor = .systemPurple
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let diamondsLabel: UILabel = {
        let label = UILabel()
        label.text = "\(DiamondManager.shared.currentDiamonds)"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .systemPurple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Добро пожаловать в лавку!"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Трать алмазы на магические предметы"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .absolute(160)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(160)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item, item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(44)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ShopCell")
        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "HeaderView"
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPurchasedBackgrounds()
        loadSelectedBackground()
        
        setupView()
        
        applySelectedBackground()
        
        
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(updateDiamondsLabel),
                name: .diamondsDidChange,
                object: nil
            )
        }

        @objc private func updateDiamondsLabel() {
            diamondsLabel.text = "\(DiamondManager.shared.currentDiamonds)"
        }

        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    
    
    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "Лавка древностей"
        
        // Добавляем header
        view.addSubview(headerView)
        headerView.addSubview(diamondImageView)
        headerView.addSubview(diamondsLabel)
        headerView.addSubview(welcomeLabel)
        headerView.addSubview(descriptionLabel)
        
        // Добавляем collectionView
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            // Header
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 120),
            
            // Алмазики
            diamondImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            diamondImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            diamondImageView.widthAnchor.constraint(equalToConstant: 30),
            diamondImageView.heightAnchor.constraint(equalToConstant: 30),
            
            diamondsLabel.centerYAnchor.constraint(equalTo: diamondImageView.centerYAnchor),
            diamondsLabel.leadingAnchor.constraint(equalTo: diamondImageView.trailingAnchor, constant: 8),
            
            // Текст
            welcomeLabel.topAnchor.constraint(equalTo: diamondImageView.bottomAnchor, constant: 12),
            welcomeLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            welcomeLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            
            // CollectionView
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //background management
    private func loadPurchasedBackgrounds(){
        let purchasedNames = UserDefaults.standard.stringArray(forKey: purchasedKey) ?? []
        for i in 0..<(itemsByCategory[.background]?.count ?? 0){
            itemsByCategory[.background]?[i].isPurchased=purchasedNames.contains(itemsByCategory[.background]?[i].name ?? "")
        }
    }
    
    private func savePurchasedBackgrounds(){
        let purchasedNames = itemsByCategory[.background]?
            .filter { $0.isPurchased }
            .map { $0.name } ?? []
        UserDefaults.standard.set(purchasedNames, forKey: purchasedKey)
    }
    
    private func loadSelectedBackground(){
        let selectedName = UserDefaults.standard.string(forKey: selectedBackgroundKey)
        
        for i in 0..<(itemsByCategory[.background]?.count ?? 0){
            itemsByCategory[.background]?[i].isSelected = (itemsByCategory[.background]?[i].name == selectedName)
        }
        applySelectedBackground()
    }
    
    private func saveSelectedBackground(_ name: String?){
        UserDefaults.standard.set(name, forKey: selectedBackgroundKey)
    }
    
    private func applySelectedBackground(){
        if let selected = itemsByCategory[.background]?.first(where: { $0.isSelected}){
            if let image = UIImage(named: selected.imageName){
                view.backgroundColor = UIColor(patternImage: image)
                collectionView.backgroundColor = .clear
            }
        } else {
            view.backgroundColor = .systemBackground
            collectionView.backgroundColor = .systemBackground
        }
    }
}

// UICollectionViewDataSource
extension ShopViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ShopItem.Category.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category = ShopItem.Category.allCases[section]
        return itemsByCategory[category]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopCell", for: indexPath)
        
        // Очищаем ячейку
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let category = ShopItem.Category.allCases[indexPath.section]
        guard let item = itemsByCategory[category]?[indexPath.row] else { return cell }
        
        // Настройка ячейки
        cell.contentView.backgroundColor = .systemBackground
        cell.contentView.layer.cornerRadius = 16
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.systemGray3.cgColor
        
        // Картинка
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: item.imageName) ?? UIImage(systemName: "photo.fill")
        imageView.tintColor = .systemPurple
        imageView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(imageView)
        
        // Название
        let nameLabel = UILabel()
        nameLabel.text = item.name
        nameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 3
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(nameLabel)
        
        // Цена
        let priceLabel = UILabel()
        priceLabel.text = "\(item.price) 💎"
        priceLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        priceLabel.textColor = .systemPurple
        priceLabel.textAlignment = .center
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(priceLabel)
        
        
        // Иконка "Куплено" для фонов
        if category == .background {
            if item.isPurchased {
                let checkmarkImageView = UIImageView()
                checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill")
                checkmarkImageView.tintColor = .systemGreen
                checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(checkmarkImageView)
        
        NSLayoutConstraint.activate([
            checkmarkImageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            checkmarkImageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -8),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 20),
             checkmarkImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
                            
    if item.isSelected {
        cell.contentView.layer.borderWidth = 3
        cell.contentView.layer.borderColor = UIColor.systemPurple.cgColor
    }
}
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 12),
            imageView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -4),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 4),
            priceLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -4)
        ])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ShopViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let category = ShopItem.Category.allCases[indexPath.section]
        guard let item = itemsByCategory[category]?[indexPath.row] else { return }
        
        if category == .background {
            handleBackgroundAction(item, at: indexPath)
        } else {
            handleOtherItemAction(item)
        }
    }
    
    private func handleBackgroundAction(_ item: ShopItem, at indexPath: IndexPath) {
            if item.isPurchased {
                let alert = UIAlertController(
                    title: item.name,
                    message: item.isSelected ? "Убрать этот фон?" : "Применить этот фон?",
                    preferredStyle: .actionSheet
                )
                
                if item.isSelected {
                                alert.addAction(UIAlertAction(title: "Убрать фон", style: .destructive) { _ in
                                    for i in 0..<(self.itemsByCategory[.background]?.count ?? 0) {
                                        self.itemsByCategory[.background]?[i].isSelected = false
                                    }
                                    self.saveSelectedBackground(nil)
                                    self.applySelectedBackground()
                                    self.collectionView.reloadData()
                                })
                            } else {
                                alert.addAction(UIAlertAction(title: "Применить фон", style: .default) { _ in
                                    for i in 0..<(self.itemsByCategory[.background]?.count ?? 0) {
                                        self.itemsByCategory[.background]?[i].isSelected = false
                                    }
                                    self.itemsByCategory[.background]?[indexPath.row].isSelected = true
                                    self.saveSelectedBackground(item.name)
                                    self.applySelectedBackground()
                                    self.collectionView.reloadData()
                                })
                            }
                            
                            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
                            present(alert, animated: true)
                            
                        } else {
                            let alert = UIAlertController(
                                title: item.name,
                                message: "Купить за \(item.price) 💎?\nУ тебя: \(DiamondManager.shared.currentDiamonds) 💎",
                                preferredStyle: .alert
                            )
        
                                let buyAction = UIAlertAction(title: "Купить", style: .default) { _ in
                                    if DiamondManager.shared.spendDiamonds(item.price) {
                                        self.itemsByCategory[.background]?[indexPath.row].isPurchased = true
                                        self.savePurchasedBackgrounds()
                                        self.collectionView.reloadItems(at: [indexPath])
                                                            
                                        let successAlert = UIAlertController(
                                            title: "Успешно!",
                                            message: "Фон куплен! Теперь его можно применить",
                                            preferredStyle: .alert
                                        )
                                        successAlert.addAction(UIAlertAction(title: "Отлично", style: .default))
                                        self.present(successAlert, animated: true)
                                    } else {
                                        let failAlert = UIAlertController(
                                            title: "Ой!",
                                            message: "Не хватает алмазов",
                                            preferredStyle: .alert
                                        )
                                        failAlert.addAction(UIAlertAction(title: "Жаль, вернусь позже!", style: .default))
                                        self.present(failAlert, animated: true)
                                    }
                                }
                                                    
                                alert.addAction(buyAction)
                                alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
                                present(alert, animated: true)
                            }
                        }
                                            
                    private func handleOtherItemAction(_ item: ShopItem) {
                        let alert = UIAlertController(
                            title: item.name,
                            message: "Купить за \(item.price) 💎?\nУ тебя: \(DiamondManager.shared.currentDiamonds) 💎",
                            preferredStyle: .alert
                        )
                                                
                        let buyAction = UIAlertAction(title: "Купить", style: .default) { _ in
                            if DiamondManager.shared.spendDiamonds(item.price) {
                                let successAlert = UIAlertController(
                                    title: "Успешно!",
                                    message: "Ты купил(а) \(item.name)",
                                    preferredStyle: .alert
                                )
                                successAlert.addAction(UIAlertAction(title: "Отлично", style: .default))
                                self.present(successAlert, animated: true)
                            } else {
                                let failAlert = UIAlertController(
                                    title: "Ой!",
                                    message: "Не хватает алмазов",
                                    preferredStyle: .alert
                                )
                                failAlert.addAction(UIAlertAction(title: "Жаль, вернусь позже!", style: .default))
                                self.present(failAlert, animated: true)
                            }
                    }
                                                
                    alert.addAction(buyAction)
                    alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
                    present(alert, animated: true)
            }
        }
                                                            
// MARK: - UICollectionViewDelegateFlowLayout
extension ShopViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "HeaderView",
            for: indexPath
        )
        
        header.subviews.forEach { $0.removeFromSuperview() }
        
        let category = ShopItem.Category.allCases[indexPath.section]
        
        let titleLabel = UILabel()
        titleLabel.text = category.rawValue
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16)
        ])
        
        return header
    }
}
