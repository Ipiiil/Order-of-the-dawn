//
//  PetProfileViewController.swift
//  CatGallery
//

import UIKit

class PetProfileViewController: UIViewController {
    
    // MARK: - Данные
    private let pets = Pet.allPets
    private var currentIndex = 0
    private var selectedPet: Pet?
    
    private var petLevel = 1
    private var petXP = 0
    private var requiredXP = 100
    
    private let defaults = UserDefaults.standard
    private let selectedKey = "selectedPetName"
    private let levelKey = "petLevel"
    private let xpKey = "petXP"
    
    
    // MARK: - UI элементы
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let petImage = UIImageView()
    private let nameLabel = UILabel()
    private let descLabel = UILabel()
    private let levelLabel = UILabel()
    private let xpProgress = UIProgressView()
    private let xpLabel = UILabel()
    private let strengthLabel = UILabel()
    private let wisdomLabel = UILabel()
    private let magicLabel = UILabel()
    
    private let prevButton = UIButton()
    private let nextButton = UIButton()
    private let selectButton = UIButton()
    private let selectionStack = UIStackView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData()
        
        if selectedPet == nil {
            showSelectionMode()
            updatePetDisplay()
        } else {
            showPetMode()
        }
        
        setupNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedPet != nil {
            checkRituals()
        }
    }
    
    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "Питомец"
        
        // Настройка scrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Картинка
        petImage.contentMode = .scaleAspectFit
        petImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(petImage)
        
        NSLayoutConstraint.activate([
            petImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            petImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            petImage.widthAnchor.constraint(equalToConstant: 180),
            petImage.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        // Имя
        nameLabel.font = .systemFont(ofSize: 28, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: petImage.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        // Описание
        descLabel.font = .systemFont(ofSize: 16)
        descLabel.textColor = .secondaryLabel
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descLabel)
        
        NSLayoutConstraint.activate([
            descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            descLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        // Кнопки выбора
        selectionStack.axis = .horizontal
        selectionStack.distribution = .equalSpacing
        selectionStack.alignment = .center
        selectionStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(selectionStack)
        
        prevButton.setTitle("◀", for: .normal)
        prevButton.titleLabel?.font = .systemFont(ofSize: 36, weight: .bold)
        prevButton.setTitleColor(.systemPurple, for: .normal)
        
        nextButton.setTitle("▶", for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 36, weight: .bold)
        nextButton.setTitleColor(.systemPurple, for: .normal)
        
        selectButton.setTitle("✨ Выбрать ✨", for: .normal)
        selectButton.backgroundColor = .systemPurple
        selectButton.setTitleColor(.white, for: .normal)
        selectButton.layer.cornerRadius = 16
        
        selectionStack.addArrangedSubview(prevButton)
        selectionStack.addArrangedSubview(selectButton)
        selectionStack.addArrangedSubview(nextButton)
        
        NSLayoutConstraint.activate([
            selectionStack.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 20),
            selectionStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            selectionStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            selectionStack.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Уровень
        levelLabel.font = .systemFont(ofSize: 20, weight: .bold)
        levelLabel.textColor = .systemPurple
        levelLabel.textAlignment = .center
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(levelLabel)
        
        NSLayoutConstraint.activate([
            levelLabel.topAnchor.constraint(equalTo: selectionStack.bottomAnchor, constant: 24),
            levelLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        // XP прогресс
        xpProgress.trackTintColor = .systemGray4
        xpProgress.progressTintColor = .systemPurple
        xpProgress.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(xpProgress)
        
        NSLayoutConstraint.activate([
            xpProgress.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 12),
            xpProgress.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            xpProgress.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            xpProgress.heightAnchor.constraint(equalToConstant: 8)
        ])
        
        // XP текст
        xpLabel.font = .systemFont(ofSize: 12)
        xpLabel.textColor = .secondaryLabel
        xpLabel.textAlignment = .center
        xpLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(xpLabel)
        
        NSLayoutConstraint.activate([
            xpLabel.topAnchor.constraint(equalTo: xpProgress.bottomAnchor, constant: 4),
            xpLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        // Статы
        strengthLabel.font = .systemFont(ofSize: 16, weight: .medium)
        strengthLabel.textAlignment = .center
        strengthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        wisdomLabel.font = .systemFont(ofSize: 16, weight: .medium)
        wisdomLabel.textAlignment = .center
        wisdomLabel.translatesAutoresizingMaskIntoConstraints = false
        
        magicLabel.font = .systemFont(ofSize: 16, weight: .medium)
        magicLabel.textAlignment = .center
        magicLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(strengthLabel)
        contentView.addSubview(wisdomLabel)
        contentView.addSubview(magicLabel)
        
        NSLayoutConstraint.activate([
            strengthLabel.topAnchor.constraint(equalTo: xpLabel.bottomAnchor, constant: 20),
            strengthLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            wisdomLabel.topAnchor.constraint(equalTo: strengthLabel.bottomAnchor, constant: 12),
            wisdomLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            magicLabel.topAnchor.constraint(equalTo: wisdomLabel.bottomAnchor, constant: 12),
            magicLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            magicLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        prevButton.addTarget(self, action: #selector(prevTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        selectButton.addTarget(self, action: #selector(selectTapped), for: .touchUpInside)
    }
    
    // MARK: - Режимы
    private func showSelectionMode() {
        selectionStack.isHidden = false
        levelLabel.isHidden = true
        xpProgress.isHidden = true
        xpLabel.isHidden = true
        strengthLabel.isHidden = true
        wisdomLabel.isHidden = true
        magicLabel.isHidden = true
    }
    
    private func showPetMode() {
        selectionStack.isHidden = true
        levelLabel.isHidden = false
        xpProgress.isHidden = false
        xpLabel.isHidden = false
        strengthLabel.isHidden = false
        wisdomLabel.isHidden = false
        magicLabel.isHidden = false
        
        updatePetDisplay()
        updateStats()
    }
    
    // MARK: - Отображение
    private func updatePetDisplay() {
        let pet = pets[currentIndex]
        petImage.image = UIImage(named: pet.imageName) ?? UIImage(systemName: "pawprint.fill")
        nameLabel.text = pet.name
        descLabel.text = pet.description
    }
    
    private func updateStats() {
        guard let pet = selectedPet else { return }
        petImage.image = UIImage(named: pet.imageName) ?? UIImage(systemName: "pawprint.fill")
        nameLabel.text = pet.name
        descLabel.text = pet.description
        
        levelLabel.text = "⭐ Уровень \(petLevel)"
        let progress = Float(petXP) / Float(requiredXP)
        xpProgress.setProgress(progress, animated: true)
        xpLabel.text = "\(petXP) / \(requiredXP) XP"
        
        let stats = 10 + petLevel * 2
        strengthLabel.text = "💪 Сила: \(stats)"
        wisdomLabel.text = "🧠 Мудрость: \(stats)"
        magicLabel.text = "✨ Магия: \(stats)"
    }
    
    // MARK: - Прокачка
    private func addXP(_ amount: Int) {
        petXP += amount
        while petXP >= requiredXP {
            petXP -= requiredXP
            petLevel += 1
            requiredXP = 100 + (petLevel - 1) * 25
            showLevelUp()
        }
        saveProgress()
        updateStats()
    }
    
    private func checkRituals() {
        let count = defaults.integer(forKey: "completedRitualsCount")
        if count > 0 {
            addXP(count * 10)
            defaults.set(0, forKey: "completedRitualsCount")
        }
    }
    
    private func showLevelUp() {
        let alert = UIAlertController(
            title: "🎉 Уровень повышен!",
            message: "Твой питомец достиг \(petLevel) уровня!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ура!", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Сохранение
    private func loadData() {
        if let saved = defaults.string(forKey: selectedKey) {
            selectedPet = pets.first { $0.name == saved }
        }
        petLevel = defaults.integer(forKey: levelKey)
        if petLevel == 0 { petLevel = 1 }
        petXP = defaults.integer(forKey: xpKey)
        requiredXP = 100 + (petLevel - 1) * 25
    }
    
    private func saveSelectedPet() {
        defaults.set(selectedPet?.name, forKey: selectedKey)
    }
    
    private func saveProgress() {
        defaults.set(petLevel, forKey: levelKey)
        defaults.set(petXP, forKey: xpKey)
    }
    
    // MARK: - Actions
    @objc private func prevTapped() {
        currentIndex = (currentIndex - 1 + pets.count) % pets.count
        updatePetDisplay()
    }
    
    @objc private func nextTapped() {
        currentIndex = (currentIndex + 1) % pets.count
        updatePetDisplay()
    }
    
    @objc private func selectTapped() {
        selectedPet = pets[currentIndex]
        saveSelectedPet()
        showPetMode()
    }
    
    // MARK: - Уведомления
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refresh),
            name: .diamondsDidChange,
            object: nil
        )
    }
    
    @objc private func refresh() {
        if selectedPet != nil {
            checkRituals()
        }
    }
}
