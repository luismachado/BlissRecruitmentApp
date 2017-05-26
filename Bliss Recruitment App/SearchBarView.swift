//
//  SearchBarView.swift
//  Bliss Recruitment App
//
//  Created by Luís Machado on 26/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

class SearchBarView: UIView, UITextFieldDelegate {
    
    var questionListController: QuestionListController?
    
    lazy var inputTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Search..."
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 3
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        return textField
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "share"), for: .normal)
        button.tintColor = .white
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
        return button
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(searchButton)
        searchButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        searchButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(shareButton)
        shareButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 0, width: 42, height: 0)
        
        addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: shareButton.rightAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: searchButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: heightAnchor, constant: -16).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissKeyboard() {
        inputTextField.resignFirstResponder()
    }
    
    func handleShare() {
        
        guard let searchTerm = inputTextField.text else { return }        
        questionListController?.handleShare(searchTerm: searchTerm)
    }
    
    func handleSearch() {
        dismissKeyboard()
        questionListController?.handleSearch()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
}

class CustomTextField : UITextField {
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
