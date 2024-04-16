//
//  ConfigLoader.swift
//  TicketMasterChallenge
//
//  Created by Kristina Borisova on 14/04/2024.
//

import Foundation

enum ConfigLoader {

    enum ConfigLoaderError: Error {
        case noConfigAvailable
        case valuesUsingPlaceholder(keys: [String])
    }

    static func loadConfig() throws -> Config {

        // Check that all parameters exist
        guard let apiKey = getParameterValue("ApiKey") else { throw ConfigLoaderError.noConfigAvailable }

        // Check that all values are not placeholders
        var keysUsingPlaceholders: [String] = []

        if !isNonPlaceholderValue(apiKey) { keysUsingPlaceholders.append("ApiKey") }
        
        if !keysUsingPlaceholders.isEmpty {
            throw ConfigLoaderError.valuesUsingPlaceholder(keys: keysUsingPlaceholders)
        }

        // Return a valid config
        return Config(
            apiKey: apiKey
        )
    }

    private static func getParameterValue(_ key: String) -> String? {
        guard let string = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            return nil
        }
        return string.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
    }

    private static func isNonPlaceholderValue(_ value: String) -> Bool {
        !value.isEmpty && value.first != "<" && value.last != ">"
    }
}
