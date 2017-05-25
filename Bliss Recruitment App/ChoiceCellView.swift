//
//  ChoiceCellView.swift
//  Bliss Recruitment App
//
//  Created by Luís Machado on 25/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

class ChoiceCellView: UICollectionViewCell {
    
    var choice: Choice? {
        didSet {
            if let choice = choice {
                choiceText.text = choice.name
                numberVotes.text = "\(choice.votes)"
            }
        }
    }
    
    var voteDelegate: VoteProtocol?
    
    let choiceText: UILabel = {
        let label = UILabel()
        label.backgroundColor = .gray
        label.text = "A QUESTION"
        return label
    }()
    
    let numberVotes: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.text = "1234"
        return label
    }()
    
    lazy var voteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Vote", for: .normal)
        button.backgroundColor = .yellow
        button.addTarget(self, action: #selector(votePressed), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    @objc fileprivate func votePressed() {
        print("vote pressed")
        if let choice = choice {
            voteDelegate?.votedOn(choice: choice)
        }
        
    }
    
    fileprivate func setupCell() {
        
        addSubview(voteButton)
        voteButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 2, paddingRight: 2, width: 50, height: 0)
        
        addSubview(numberVotes)
        numberVotes.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: voteButton.leftAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 2, paddingRight: 4, width: 50, height: 0)
        
        addSubview(choiceText)
        choiceText.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: numberVotes.leftAnchor, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 4, width: 0, height: 0)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

