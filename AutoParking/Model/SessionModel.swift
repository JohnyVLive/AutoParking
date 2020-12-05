//
//  SessionModel.swift
//  AutoParking
//
//  Created by Evgeniy Radchenko on 02.12.2020.
// 

import Foundation

class SessionModel {
    private var success: Bool
    private var sessionID: String
    
    static let shared = SessionModel()
    
    private init()
    {
        self.success = false
        self.sessionID = "";
    }
    
    func set(_ success: Bool, _ sessionID: String){
        self.success = success
        self.sessionID = sessionID
    }
    
    func getSuccess() -> Bool{
        return self.success
    }
    
    func getSessionID() -> String{
        return self.sessionID
    }
}
