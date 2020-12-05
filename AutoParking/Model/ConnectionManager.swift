//
//  SessionManager.swift
//  AutoParking
//
//  Created by Evgeniy Radchenko on 02.12.2020.
//

import Foundation

protocol ConnectionManagerDelegate {
    func didUpdateSID()
    func didUpdateLPR(lpr: [LPRModel])
    func didFailWithConnection(error: Error)
}

class ConnectionManager: NSObject{
    
    let connectURL = K.connectURL
    let passwordCommand = K.passwordCommand
    let lprCommand = K.lprCommand
    let SDKPassword: String = K.SDKPassword
    
    
    var lprEventsArray = [LPRModel]()
    var delegate: ConnectionManagerDelegate?
        
    func createSession(){
        let connectURL = self.connectURL + passwordCommand + SDKPassword
        performRequest(with: connectURL, and: "session")
    }
    
    func loadLPR(with sid: String){
        if SessionModel.shared.getSuccess(){
            let sid = SessionModel.shared.getSessionID()
            let connectURL = self.connectURL + lprCommand + "sid=\(sid)"
            //TODO: - Remove print
//            print(connectURL)
            self.performRequest(with: connectURL, and: "lpr")
            
        } else {
            createSession()
        }
    }
    
    //TODO: - Need to fix secure connection in PList. Delete arbitary loads and create exeption for specific URL

    func performRequest(with urlString: String, and type: String){
        if let url = URL(string: urlString){
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error as NSError? {
                    NSLog("task transport error %@ / %d", error.domain, error.code)
                    return
                }
                if let safeData = data{
                    let response = response as! HTTPURLResponse
                    //TODO: - Remove NSLog
                    NSLog("task finished with status %d, bytes %d", response.statusCode, data!.count)
                    switch type {
                    case "session":
                        self.parseSession(safeData)
                        
                    case "lpr":
                        if let lprData = self.parseLPR(safeData){
                            self.delegate?.didUpdateLPR(lpr: lprData)
                        }
                    default:
                        print("No connection type")
                    }

                }
            }
            task.resume()
        }
    }

    func parseSession(_ receivedData: Data){
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(SessionData.self, from: receivedData)
            let success = decodedData.success == 1 ? true : false
            let sid = decodedData.sid
            SessionModel.shared.set(success, sid)
            self.delegate?.didUpdateSID()
        } catch {
            delegate?.didFailWithConnection(error: error)
        }
    }
    
    //Parsing data of LPR events and creating an array
    func parseLPR(_ receivedData: Data) -> [LPRModel]?{
        var lprEvents = [LPRModel]()
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode([LPRData].self, from: receivedData)
            for data in decodedData{
                let idString = data.id
                let bestGuess = data.best_guess
                let channel = data.best_guess
                let plate = data.plate
                let qualityString = data.quality
                let template = data.template
                let timeBestView = data.time_bestview
                let info = data.lists
                let flags = data.flags

                let lprEvent = LPRModel(idString: idString, bestGuess: bestGuess, channel: channel, plate: plate, qualityString: qualityString, template: template, timeBestView: timeBestView, info: info, flags: flags)

                lprEvents.append(lprEvent)
            }
            return lprEvents
            
        } catch {
            delegate?.didFailWithConnection(error: error)
            return nil
        }
    }
    
}

//MARK: - URLSession Delegate for unsecure connection
extension ConnectionManager: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
       //Trust the certificate even if not valid
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

       completionHandler(.useCredential, urlCredential)
    }
}
