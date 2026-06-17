//
//  ShopItem.swift
//  CatGallery
//
//  Created by Полина Терехина on 20.02.2026.
//

import Foundation

struct ShopItem {
    let name: String
    let price: Int
    let imageName: String
    let category: Category
    var isPurchased: Bool = false // есть ли фон
    var isSelected: Bool = false // применен ли фон
    
    enum Category: String, CaseIterable {
        case background = "Фоны"
        case figurine = "Фигурки"
        case scroll = "Свитки"
        
        var systemImage: String {
            switch self {
            case .background: return "photo.fill"
            case .figurine: return "figure.walk"
            case .scroll: return "scroll.fill"
            }
        }
    }
}


extension ShopItem {
    static var mockItems: [ShopItem] = [
        // Фоны
        ShopItem(name: "Ночное небо", price: 50, imageName: "bg_night", category: .background),
        ShopItem(name: "Запретный лес", price: 60, imageName: "bg_forest", category: .background),
        ShopItem(name: "Заброшенная лаборатория", price: 75, imageName: "bg_laboratory", category: .background),
        
        // Фигурки
        ShopItem(name: "Мудрая сова", price: 30, imageName: "fig_owl", category: .figurine),
        ShopItem(name: "Верный волк", price: 40, imageName: "fig_wolf", category: .figurine),
        
        // Свитки
        ShopItem(name: "Древнее заклинание", price: 25, imageName: "scroll_ancient", category: .scroll),
        ShopItem(name: "Пророчество", price: 45, imageName: "scroll_prophecy", category: .scroll)
    ]
}
