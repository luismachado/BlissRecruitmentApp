//
//  ShareController.swift
//  Bliss Recruitment App
//
//  Created by Luís Machado on 25/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

class ShareController: UIViewController {
    
    let urlContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .green
        return container
    }()
    
    let urlLabel: UILabel = {
        let label = UILabel()
        label.text = "Path to share"
        return label
    }()
    
    let url: UILabel = {
        let label = UILabel()
        label.text = "blissapplications://blablablabla"
        label.textAlignment = .center
        return label
    }()
    
    let emailContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .yellow
        return container
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Send to"
        return label
    }()
    
    let email: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter email..."
        tf.keyboardType = .emailAddress
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 4
        tf.clipsToBounds = true
        return tf
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(sendPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        
        view.backgroundColor = .gray
        navigationItem.title = "Share"
        
        setup()
        
    }
    
    func sendPressed() {
        
        let spinner = AlertHelper.progressBarDisplayer(msg: "Sharing...", true, view: self.view)
        self.view.addSubview(spinner)
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let onCompletion = {
            spinner.removeFromSuperview()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
        BlissAPI.shared.share(destinationEmail: "email@email.com", contentUrl: "blissapplications://123", success: {
            print("success")
            onCompletion()
            AlertHelper.displayAlert(title: "Share", message: "Shared successfully", displayTo: self, completion: { (action) in
                
                self.navigationController?.dismiss(animated: true, completion: nil)
            })
        }) { (error) in
            print(error)
            onCompletion()
            AlertHelper.displayAlert(title: "Share", message: "Unable to share the url. Please try again.", displayTo: self)
        }
        
        //TODO CHECK EMAIL
        
    }
    
    private func setup() {
        
        view.addSubview(urlContainer)
        urlContainer.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 70)
        
        urlContainer.addSubview(urlLabel)
        urlLabel.anchor(top: urlContainer.topAnchor, left: urlContainer.leftAnchor, bottom: nil, right: urlContainer.rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 20)
        
        urlContainer.addSubview(url)
        url.anchor(top: urlLabel.bottomAnchor, left: urlContainer.leftAnchor, bottom: urlContainer.bottomAnchor, right: urlContainer.rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
        
        view.addSubview(emailContainer)
        emailContainer.anchor(top: urlContainer.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 70)
        
        emailContainer.addSubview(emailLabel)
        emailLabel.anchor(top: emailContainer.topAnchor, left: emailContainer.leftAnchor, bottom: nil, right: emailContainer.rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: 20)
        
        emailContainer.addSubview(email)
        email.anchor(top: emailLabel.bottomAnchor, left: emailContainer.leftAnchor, bottom: emailContainer.bottomAnchor, right: emailContainer.rightAnchor, paddingTop: 4, paddingLeft: 30, paddingBottom: 4, paddingRight: 30, width: 0, height: 0)
        
        view.addSubview(sendButton)
        sendButton.anchor(top: emailContainer.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 20)
        sendButton.centerXAnchor.constraint(equalTo: emailContainer.centerXAnchor).isActive = true
    }
    
    
    
}
