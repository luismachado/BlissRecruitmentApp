//
//  LoadingController.swift
//  Bliss Recruitment App
//
//  Created by Luís Machado on 25/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit
import SwiftSpinner

class LoadingController: UIViewController {
    
    var questionListController:QuestionListController?
    
    func delay(seconds: Double, completion: @escaping () -> ()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkServerHealth()
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func checkServerHealth() {
        SwiftSpinner.show("Checking server health")
        BlissAPI.shared.checkHealth(success: {
            SwiftSpinner.show("Server OK.", animated: false)
            self.delay(seconds: 1.0, completion: {
                SwiftSpinner.hide()
                self.questionListController?.startController()
                _ = self.navigationController?.popViewController(animated: true)

            })
        }) { (error) in
            self.delay(seconds: 1.0, completion: {
                SwiftSpinner.hide({
                    SwiftSpinner.show("Failed to connect. Retry?",animated: false).addTapHandler({
                        self.checkServerHealth()
                    }, subtitle: "Tap to Retry")
                })
            })
            
        }
    }
    
}
