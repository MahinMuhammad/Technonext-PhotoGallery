//
//  AppConfig.swift
//  PicBook
//
//  Created by Md. Mahinur Rahman on 9/4/25.
//

import Foundation

enum AppConfigService {
    static var apiBaseURL: URL {
        guard
            let raw = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String,
            let url = URL(string: raw)
        else {
            fatalError("Missing or invalid API_BASE_URL in Info.plist")
        }
        return url
    }
    
    static var appEnv: String {
        guard
            let raw = Bundle.main.object(forInfoDictionaryKey: "APP_ENV") as? String
        else {
            fatalError("Missing or invalid APP_ENV in Info.plist")
        }
        return raw
    }
}
