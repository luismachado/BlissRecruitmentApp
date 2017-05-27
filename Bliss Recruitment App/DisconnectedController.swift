//
//  DisconnectedController.swift
//  Bliss Recruitment App
//
//  Created by Luís Machado on 26/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit
import SwiftSpinner

class DisconnectedController: UIViewController {
    
    func delay(seconds: Double, completion: @escaping () -> ()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = navigationColor
        SwiftSpinner.show("Connectivity Lost. Trying to reconnect...")
        navigationController?.isNavigationBarHidden = true
    }
    
    func regainedConnectivity(completion: @escaping () -> ()) {
        SwiftSpinner.show("Connected",animated: false)
        self.delay(seconds: 1.0, completion: {
            SwiftSpinner.hide()
            self.dismiss(animated: true, completion: { 
                completion()
            })
        })
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
}
