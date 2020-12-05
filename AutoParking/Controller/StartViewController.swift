//
//  ViewController.swift
//  AutoParking
//
//  Created by Evgeniy Radchenko on 02.12.2020.
//

import UIKit

class StartViewController: UIViewController {

    var connectionManager = ConnectionManager()
    var lprEventsArray = [LPRModel]()
    
    
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

    func didUpdateSID(){
        DispatchQueue.main.sync {
            if SessionModel.shared.getSuccess() {
                performSegue(withIdentifier: "gotoEvents", sender: self)
            }
        }
    }
    
    func didUpdateLPR(lpr: [LPRModel]) {
    }
    
    func didFailWithConnection(error: Error) {
        print(error)
    }
}
