//
//  UnityRitualViewController.swift
//  CatGallery
//
//  Created by Полина Терехина on 10.04.2026.
//

import UIKit

class UnityRitualViewController: UIViewController {
    
    // Constants
    private let lastUnityDateKey = "lastUnityRitualDate"
    
    // UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Единение стихий ✨"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Раз в день ты можешь соединить энергии трёх источников и получить магическую награду."
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sourcesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let earthView = SourceView(sourceName: "Земля", iconName: "leaf.fill", color: .systemGreen)
    private let starsView = SourceView(sourceName: "Звёзды", iconName: "star.fill", color: .systemYellow)
    private let moonView = SourceView(sourceName: "Луна", iconName: "moon.fill", color: .systemIndigo)
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Провести единение 🌙", for: .normal)
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "Нажми на кнопку, чтобы начать ✨"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .systemPurple
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemPurple
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let cooldownLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var sourceResults: [String: Int] = [:]
    
    //  Properties
    private var canPerformRitual: Bool {
        let lastDate = UserDefaults.standard.object(forKey: lastUnityDateKey) as? Date ?? .distantPast
        return !Calendar.current.isDateInToday(lastDate)
    }
    
    private var timeUntilNextRitual: String {
        let nextDate = Calendar.current.startOfDay(for: Date().addingTimeInterval(86400))
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date(), to: nextDate)
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        return "\(hours)ч \(minutes)м"
    }
    
    //  Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupActions()
        updateUIForRitualState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUIForRitualState()
    }
    
    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "Единение"
        
        sourcesStackView.addArrangedSubview(earthView)
        sourcesStackView.addArrangedSubview(starsView)
        sourcesStackView.addArrangedSubview(moonView)
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(sourcesStackView)
        view.addSubview(actionButton)
        view.addSubview(resultLabel)
        view.addSubview(activityIndicator)
        view.addSubview(cooldownLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            sourcesStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            sourcesStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sourcesStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sourcesStackView.heightAnchor.constraint(equalToConstant: 130),
            
            actionButton.topAnchor.constraint(equalTo: sourcesStackView.bottomAnchor, constant: 40),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 240),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            
            resultLabel.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 24),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            cooldownLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 16),
            cooldownLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cooldownLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cooldownLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupActions() {
        actionButton.addTarget(self, action: #selector(startUnityRitual), for: .touchUpInside)
    }
    
    private func updateUIForRitualState() {
        if canPerformRitual {
            actionButton.isEnabled = true
            actionButton.alpha = 1.0
            cooldownLabel.text = "Ритуал доступен сегодня ✨"
            cooldownLabel.textColor = .systemGreen
        } else {
            actionButton.isEnabled = false
            actionButton.alpha = 0.6
            cooldownLabel.text = "Ритуал доступен через: \(timeUntilNextRitual)"
            cooldownLabel.textColor = .systemOrange
        }
    }
    
    // Ritual Logic
    @objc private func startUnityRitual() {
        guard canPerformRitual else {
            let alert = UIAlertController(
                title: "Ритуал уже проведён ✨",
                message: "Единение стихий доступно раз в день.\nВозвращайся через \(timeUntilNextRitual)",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Хорошо", style: .default))
            present(alert, animated: true)
            return
        }
        
        resetSources()
        sourceResults.removeAll()
        resultLabel.text = "Собираем энергию стихий... ✨"
        
        activityIndicator.startAnimating()
        actionButton.isEnabled = false
        
        Task {
            let results = await performRitual()
            
            await MainActor.run {
                self.activityIndicator.stopAnimating()
                self.actionButton.isEnabled = true
                self.completeRitual(with: results)
            }
        }
    }
    
    private func performRitual() async -> [String: Int] {
        // Запускаем три задачи параллельно
        async let earth = fetchEnergy(for: "Земля", delay: 1.0...3.0, range: 30...50)
        async let stars = fetchEnergy(for: "Звёзды", delay: 1.0...3.0, range: 25...60)
        async let moon = fetchEnergy(for: "Луна", delay: 1.0...3.0, range: 20...55)
        
        // Ждём все три результата
        let (earthResult, starsResult, moonResult) = await (earth, stars, moon)
        
        var results: [String: Int] = [:]
        results["Земля"] = earthResult.energy
        results["Звёзды"] = starsResult.energy
        results["Луна"] = moonResult.energy
        
        // Обновляем UI на главном потоке
        await MainActor.run {
            earthView.completeLoading(withEnergy: earthResult.energy)
            starsView.completeLoading(withEnergy: starsResult.energy)
            moonView.completeLoading(withEnergy: moonResult.energy)
        }
        
        return results
    }
    
    private func fetchEnergy(for source: String, delay range: ClosedRange<Double>, range energyRange: ClosedRange<Int>) async -> (source: String, energy: Int) {
        let delay = Double.random(in: range)
        
        // Имитация задержки
        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        
        let energy = Int.random(in: energyRange)
        return (source, energy)
    }
    
    //  Completion
    private func completeRitual(with results: [String: Int]) {
        let totalEnergy = results.values.reduce(0, +)
        let reward = 10
        DiamondManager.shared.addDiamonds(reward)
        
        UserDefaults.standard.set(Date(), forKey: lastUnityDateKey)
        
        let message = """
        🔮 Единение завершено!
        
        🌍 Энергия Земли: \(results["Земля"] ?? 0)
        ✨ Энергия Звёзд: \(results["Звёзды"] ?? 0)
        🌙 Энергия Луны: \(results["Луна"] ?? 0)
        
        Общая сила: \(totalEnergy)
        Ты получаешь +\(reward) 💎
        """
        
        resultLabel.text = message
        
        let alert = UIAlertController(
            title: "✨ Ритуал завершён ✨",
            message: "Ты получил(а) \(reward) 💎\nБлагодарим за единение!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Благодарю", style: .default))
        present(alert, animated: true)
        
        updateUIForRitualState()
    }
    
    private func resetSources() {
        earthView.reset()
        starsView.reset()
        moonView.reset()
    }
}

//  SourceView
class SourceView: UIView {
    
    private let sourceName: String
    private let iconName: String
    private let accentColor: UIColor
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray3.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let energyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    init(sourceName: String, iconName: String, color: UIColor) {
        self.sourceName = sourceName
        self.iconName = iconName
        self.accentColor = color
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        iconImageView.image = UIImage(systemName: iconName)
        iconImageView.tintColor = accentColor
        nameLabel.text = sourceName
        nameLabel.textColor = .label
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(energyLabel)
        containerView.addSubview(activityIndicator)
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 12),
            nameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            energyLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            energyLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            energyLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: energyLabel.centerYAnchor)
        ])
    }
    
    func startLoading() {
        energyLabel.isHidden = true
        activityIndicator.startAnimating()
        containerView.layer.borderColor = accentColor.cgColor
        containerView.layer.borderWidth = 2
    }
    
    func completeLoading(withEnergy energy: Int) {
        activityIndicator.stopAnimating()
        energyLabel.isHidden = false
        energyLabel.text = "⚡ \(energy)"
        energyLabel.textColor = accentColor
        containerView.layer.borderColor = UIColor.systemGray3.cgColor
        containerView.layer.borderWidth = 1
    }
    
    func reset() {
        activityIndicator.stopAnimating()
        energyLabel.isHidden = true
        containerView.layer.borderColor = UIColor.systemGray3.cgColor
        containerView.layer.borderWidth = 1
        energyLabel.text = nil
    }
}
