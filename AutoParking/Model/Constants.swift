//
//  Constants.swift
//  AutoParking
//
//  Created by Evgeniy Radchenko on 05.12.2020.
//
// Test gitignore

import Foundation

struct K {
    
    //Connection parameters
    static let connectURL: String = "https://v1.moskbk.com:8081/"
    static let passwordCommand = "login?password="
    static let lprCommand = "lpr_events?"
    
    static let SDKPassword: String = "12345"
    
    
    
    //LPR Flags
    static let flagsArray = [("LPR_BLACKLIST", 4),
                             ("LPR_CORRECTED", 64),
                             ("LPR_DOWN", 2),
                             ("LPR_EXT_DB_ERROR", 32),
                             ("LPR_INFO", 16),
                             ("LPR_UP", 1),
                             ("LPR_WHITELIST", 8),
                ]
    
}
