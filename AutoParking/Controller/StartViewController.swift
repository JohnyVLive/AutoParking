//
//  ViewController.swift
//  AutoParking
//
//  Created by Evgeniy Radchenko on 02.12.2020.
//

import UIKit

class StartViewController: UIViewController {

    var connectionManager = ConnectionManager()
    var lprEvents = [LPRModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        connectionManager.delegate = self
        
    }

    @IBAction func connectButtonPressed(_ sender: UIButton) {
        connectionManager.createSession()
    }
}

//MARK: - ConnectionManager Delegate
extension StartViewController: ConnectionManagerDelegate{

    func didUpdateSID(session: SessionModel) {
        connectionManager.loadLPR(sid: session)
    }
    
    func didUpdateLPR(lpr: [LPRModel]) {
        lprEvents = lpr
        print("Array of events has been loaded")
        var avarageQuality: Double = 0.0
        
        for event in lprEvents {
            print("\(event.bestGuess) - \(event.quality) - \(event.direction)")
            avarageQuality += event.quality
        }
        print("\nAvarage quality: \(avarageQuality / Double(lprEvents.count))")
//        for event in lpr{
//            //TODO: - Remove print
//            print("\(event.bestGuess) - \(event.quality)")
//
//            lprEvents.append(event)
//        }
        
    }
    
    func didFailWithConnection(error: Error) {
        print(error)
    }
}
