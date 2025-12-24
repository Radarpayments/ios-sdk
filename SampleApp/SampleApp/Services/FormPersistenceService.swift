//
//  FormPersistenceService.swift
//  MyStore
//

import Foundation

final class FormPersistenceService {
    static let shared = FormPersistenceService()

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func value(for config: FormFieldConfig) -> String {
        userDefaults.string(forKey: config.fieldKey) ?? config.defaultValue
    }

    func set(_ value: String, for config: FormFieldConfig) {
        userDefaults.set(value, forKey: config.fieldKey)
    }
}
