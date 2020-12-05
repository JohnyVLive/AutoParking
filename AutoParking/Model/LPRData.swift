//
//  NumbersData.swift
//  AutoParking
//
//  Created by Evgeniy Radchenko on 02.12.2020.
//

import Foundation

struct LPRData: Decodable {
    
    let id: String
    let best_guess: String
    let channel: String
    let plate: String
    let quality: String
    let template: String
    let time_bestview: String
    let flags: String
    let lists: String
}

