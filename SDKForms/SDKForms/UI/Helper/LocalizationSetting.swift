//
//  LocalizationSetting.swift
//  SDKForms
//
// 
//

import Foundation

final class LocalizationSetting {
    
    static let shared = LocalizationSetting()
    
    private var locale: Locales = .en
    
    private init() {}
    
    func getDefaultLanguage() -> Locales {
        Locales.en
    }
    
    func setLanguage(locale: Locales) {
        self.locale = locale
    }
    
    func getLanguage() -> Locales? {
        locale
    }
    
    func getLanguageWithDefault(defaultLanguage: Locales) -> Locales {
        if let language = getLanguage() { return language }
        
        setLanguage(locale: defaultLanguage)
        return defaultLanguage
    }
}
