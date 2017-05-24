//
//  QuestionListCellView.swift
//  Bliss Recruitment App
//
//  Created by Luís Machado on 24/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

class QuestionListCellView: UICollectionViewCell {
    
    let thumbnail: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .green
        return image
    }()
    
    let question: UILabel = {
        let label = UILabel()
        label.backgroundColor = .gray
        label.text = "A QUESTION"
        return label
    }()
    
    let date: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.text = "date"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    fileprivate func setupCell() {
        
        backgroundColor = .brown
        
        addSubview(thumbnail)
        thumbnail.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 54, height: 0)
        
        addSubview(date)
        date.anchor(top: nil, left: thumbnail.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 8, paddingRight: 8, width: 0, height: 12)
        
        addSubview(question)
        question.anchor(top: topAnchor, left: thumbnail.rightAnchor, bottom: date.topAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 4, paddingRight: 8, width: 0, height: 0)    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
