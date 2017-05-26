//
//  QuestionListCellView.swift
//  Bliss Recruitment App
//
//  Created by Luís Machado on 24/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

class QuestionListCellView: UICollectionViewCell {
    
    var question: Question? {
        didSet {
            questionText.text = question?.question
            thumbnail.image = nil
            
            if let thumbnailUrl = question?.thumbUrl {
                thumbnail.loadImageUsingUrlString(urlString: thumbnailUrl, completion: nil)
            }
            
            if let publishedAt = question?.publishedAt {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = Question.presentationFormat
                date.text = dateFormatter.string(from: publishedAt)
            }
        }
    }
    
    let thumbnail: QuestionImageView = {
        let image = QuestionImageView()
        image.layer.cornerRadius = 4
        image.clipsToBounds = true
        return image
    }()
    
    let questionText: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "A QUESTION"
        return label
    }()
    
    let date: UILabel = {
        let label = UILabel()
        label.text = "date"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    fileprivate func setupCell() {
        
        //backgroundColor = .brown
        
        addSubview(thumbnail)
        thumbnail.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 54, height: 0)
        
        addSubview(date)
        date.anchor(top: nil, left: thumbnail.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 12)
        
        addSubview(questionText)
        questionText.anchor(top: topAnchor, left: thumbnail.rightAnchor, bottom: date.topAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 4, paddingRight: 8, width: 0, height: 0)
    
        addSubview(separator)
        separator.anchor(top: nil, left: questionText.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
