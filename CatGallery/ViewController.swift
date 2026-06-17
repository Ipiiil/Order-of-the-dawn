//
//  ViewController.swift
//  CatGallery
//
//  Created by Полина Терехина on 31.01.2026.
//

import UIKit

class ViewController: UIViewController {
    
    let cats = [
        (title: "Котик номер раз", imageName: "kitty1"),
        (title: "Котик номер два", imageName: "kitty2"),
        (title: "Котик номер три", imageName: "kitty3")
    ]
    
    var currentIndex = 0
    
    private let titleLabel = UILabel()
    private let catImageView = UIImageView()
    private let prevButton = UIButton()
    private let nextButton = UIButton()
    private let pageLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        catImageView.contentMode = .scaleAspectFit
        catImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(catImageView)
        
        prevButton.setTitle("Назад", for: .normal)
        prevButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        prevButton.setTitleColor(.white, for: .normal)
        prevButton.backgroundColor = .systemBlue
        prevButton.layer.cornerRadius = 12
        prevButton.addTarget(self, action: #selector(prevButtonTapped), for: .touchUpInside)
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(prevButton)
        

        nextButton.setTitle("Вперед", for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.layer.cornerRadius = 12
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            catImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            catImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            catImageView.widthAnchor.constraint(equalToConstant: 300),
            catImageView.heightAnchor.constraint(equalToConstant: 300),
            

            prevButton.topAnchor.constraint(equalTo: catImageView.bottomAnchor, constant: 40),
            prevButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            prevButton.widthAnchor.constraint(equalToConstant: 120),
            prevButton.heightAnchor.constraint(equalToConstant: 50),
            
            
            nextButton.topAnchor.constraint(equalTo: catImageView.bottomAnchor, constant: 40),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            nextButton.widthAnchor.constraint(equalToConstant: 120),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func updateUI() {
        let cat = cats[currentIndex]
        titleLabel.text = cat.title
        catImageView.image = UIImage(named: cat.imageName)
    }
    
    @objc private func prevButtonTapped(){
        if currentIndex > 0 {
            currentIndex -= 1
            updateUI()
        } else {
            currentIndex = cats.count - 1//зацикливаем
        }
        updateUI()
    }
    
    @objc private func nextButtonTapped(){
        if currentIndex < cats.count - 1 {
            currentIndex += 1
            updateUI()
        }else {
            currentIndex = 0// зацикливание
        }
        updateUI()
    }
}

