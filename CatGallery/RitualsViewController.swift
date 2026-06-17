//
//  RitualsViewController.swift
//  CatGallery
//
//  Created by Полина Терехина on 13.02.2026.
//

import UIKit

class RitualsViewController: UIViewController{
    //Data
    private var rituals: [Ritual] = [
        Ritual(name: "Утреннее очищение", description: "10 минут спокойной музыки", reward: 30),
        Ritual(name: "Изучение книги заклинаний", description: "Прочесть 30 страниц книги", reward: 50),
        Ritual(name: "Тренировка по квиддичу", description: "20 приседаний", reward: 40),
        Ritual(name: "Вечерний отход в опочивальню", description: "Лечь спать до 23/00", reward: 100)
    ]
    
    //UI
    private let selectedRitualLabel: UILabel = {
        let label = UILabel()
        label.text = "Ритуал не выбран"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RitualCell")
        return tableView
    }()
    
    //life
    override func viewDidLoad() {
            super.viewDidLoad()
            setupView()
        }
    
    //setup
    private func setupView(){
        view.backgroundColor = .systemBackground
        title = "Ритуалы"
        
        view.addSubview(selectedRitualLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            selectedRitualLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            selectedRitualLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectedRitualLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            selectedRitualLabel.heightAnchor.constraint(equalToConstant: 30),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: selectedRitualLabel.bottomAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension RitualsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rituals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RitualCell", for: indexPath)
        let ritual = rituals[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = ritual.name
        content.secondaryText = "\(ritual.reward) 💎"
        content.image = UIImage(systemName: "sparkles")
        content.imageProperties.tintColor = .systemPurple
        
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension RitualsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let ritual = rituals[indexPath.row]
        selectedRitualLabel.text = "Выбран: \(ritual.name)"
        
        let alert = UIAlertController(
            title: ritual.name,
            message: "\(ritual.description)\nНаграда: \(ritual.reward) 💎",
            preferredStyle: .alert
        )
        
        let acceptAction = UIAlertAction(title: "Принять ритуал", style: .default) { _ in
            DiamondManager.shared.addDiamonds(ritual.reward)
            
            // Счётчик для питомца
            let count = UserDefaults.standard.integer(forKey: "completedRitualsCount")
            UserDefaults.standard.set(count + 1, forKey: "completedRitualsCount")
            NotificationCenter.default.post(name: .diamondsDidChange, object: nil)
            
            let successAlert = UIAlertController(
                title: "Ритуал выполнен!",
                message: "Ты получил(а) \(ritual.reward) 💎",
                preferredStyle: .alert
            )
            successAlert.addAction(UIAlertAction(title: "Супер!", style: .default))
            self.present(successAlert, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
