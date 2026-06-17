//
//  DiamondManager.swift
//  CatGallery
//
//  Created by Полина Терехина on 20.02.2026.
//
import Foundation

class DiamondManager {
    static let shared = DiamondManager()
    private let defaults = UserDefaults.standard
    private let diamondKey = "diamondsCount"
    
    var currentDiamonds: Int {
        get {
            return defaults.integer(forKey: diamondKey)
        }
        set {
            defaults.set(newValue, forKey: diamondKey)
            // Уведомляем все экраны об изменении
            NotificationCenter.default.post(name: .diamondsDidChange, object: nil)
        }
    }
    
    private init() {
        // При первом запуске ставим 150 алмазов
        if !defaults.bool(forKey: "hasLaunchedBefore") {
            defaults.set(150, forKey: diamondKey)
            defaults.set(true, forKey: "hasLaunchedBefore")
        }
    }
    
    func addDiamonds(_ amount: Int) {
        currentDiamonds += amount
    }
    
    func spendDiamonds(_ amount: Int) -> Bool {
        if currentDiamonds >= amount {
            currentDiamonds -= amount
            return true
        }
        return false
    }
}

extension Notification.Name {
    static let diamondsDidChange = Notification.Name("diamondsDidChange")
}
