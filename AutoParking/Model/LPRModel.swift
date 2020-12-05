//
//  LPRModel.swift
//  AutoParking
//
//  Created by Evgeniy Radchenko on 02.12.2020.
//

import Foundation

struct LPRModel {
    
    let idString: String?
    let bestGuess: String
    let channel: String
    let plate: String
    let qualityString: String
    let template: String
    let timeBestView: String
    let info: String
    let flags: String
    
    //Computed variables
    var id: Int {
        return Int(idString!) ?? 0
    }
    var direction: String{
        if let intFlags = Int(flags){
            if intFlags & 1 == 1{
                return "LPR_UP"
            }
            if intFlags & 2 == 2{
                return "LPR_DOWN"
            }
            return "Unkhown Direction 1"
        }
        return "Unkhown Direction 2"
    }
    var time: Date {
        let t1 = Date(timeIntervalSince1970: Double(timeBestView)! / 1000000)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

//        return dateFormatter.string(from: t1)
        return t1
    }
    var quality: Double{
        return Double(qualityString) ?? 0.0
    }
        
    
//    init(_ idString: String, _ bestGuess: String, _ channel: String, _ plate: String,
//         _ qualityString: String, _ template: String, _ timeBestView: String, _ info: String, _ flags: String) {
//        self.idString = idString
//        self.bestGuess = bestGuess
//        self.channel = channel
//        self.plate = plate
//        self.qualityString = qualityString
//        self.template = template
//        self.timeBestView = timeBestView
//        self.info = info
//        self.flags = flags
//    }


    //Optional method to collect all flags in event
    func checkFlags(flags: String){
        
        
        var resultFlags = [String]()
        
        let intFlags = Int(flags)!
        for flag in K.flagsArray {
            if intFlags & flag.1 == flag.1{
                resultFlags.append(flag.0)
            }
        }
        print(resultFlags)
    }

}


