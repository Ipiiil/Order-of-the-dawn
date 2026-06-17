//
//  Pet.swift
//  CatGallery
//
//  Created by Полина Терехина on 08.05.2026.
//

import Foundation

struct Pet: Codable {
    let name: String
    let imageName: String
    let description: String
    let bonusStat: String
    let bonusValue: Int
    
    static let allPets: [Pet] = [
        Pet(name: "Мудрый волк", imageName: "wolf", description: "Верный спутник, дарует силу", bonusStat: "Сила", bonusValue: 5),
        Pet(name: "Лунная сова", imageName: "owl", description: "Хранительница тайн, дарует мудрость", bonusStat: "Мудрость", bonusValue: 5),
        Pet(name: "Изумрудный змей", imageName: "snake", description: "Древний мудрец, дарует магию", bonusStat: "Магия", bonusValue: 5),
        Pet(name: "Огненный феникс", imageName: "phoenix", description: "Символ возрождения", bonusStat: "Все статы", bonusValue: 2),
        Pet(name: "Пушистый дракончик", imageName: "dragon", description: "Маленький хранитель удачи", bonusStat: "Удача", bonusValue: 10)
    ]
}
