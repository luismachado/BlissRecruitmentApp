//
//  QuestionDetailController.swift
//  Bliss Recruitment App
//
//  Created by Luís Machado on 24/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

class QuestionDetailController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, VoteProtocol {
    
    var question: Question? {
        didSet {
            questionName.text = question?.question
            
            if let imageUrl = question?.imageUrl {
                //thumbnail.loadImageUsingUrlString(urlString: imageUrl)
                thumbnail.loadImageUsingUrlString(urlString: imageUrl, completion: { 
                    self.updateThumbnailSizeFor(frameSize: self.view.frame.size)
                })
            }
        }
    }
    
    private func updateThumbnailSizeFor(frameSize: CGSize) {
        var height = defaultThumbnailHeight
        thumbnailWidthAnchor?.constant = -16
        
        if let image = thumbnail.image {
            print("here")
            let ratio = image.size.height / image.size.width
            
            if let constant = thumbnailWidthAnchor?.constant {
                let imgWidth = frameSize.width + constant
                height = ratio * imgWidth
            }
        }
        
        thumbnailHeightAnchor?.constant = CGFloat(height)
        
    }
    
    let defaultThumbnailHeight: CGFloat = 200
    let thumbnail: QuestionImageView = {
        let imageView = QuestionImageView()
        imageView.backgroundColor = .yellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let questionName: UILabel = {
        let label = UILabel()
        label.text = "QUESTION QUESTION QUESTION"
        label.backgroundColor = .gray
        return label
    }()
    
    let choicesCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .green
        return cv
    }()
    
    var thumbnailWidthAnchor: NSLayoutConstraint?
    var thumbnailHeightAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        view.addSubview(thumbnail)
        thumbnail.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8).isActive = true
        thumbnail.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        thumbnailWidthAnchor = thumbnail.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16)
        thumbnailWidthAnchor?.isActive = true
        thumbnailHeightAnchor = thumbnail.heightAnchor.constraint(equalToConstant: defaultThumbnailHeight)
        thumbnailHeightAnchor?.isActive = true
        
        view.addSubview(questionName)
        questionName.anchor(top: thumbnail.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 26)
        
        view.addSubview(choicesCollectionView)
        choicesCollectionView.anchor(top: questionName.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)

        choicesCollectionView.delegate = self
        choicesCollectionView.dataSource = self
        choicesCollectionView.register(ChoiceCellView.self, forCellWithReuseIdentifier: "choiceCellId")
        
    }
    
    func votedOn(choice: Choice) {
        print("Voted in \(choice.name)")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let question = question {
            return question.choices.count
        }
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "choiceCellId", for: indexPath) as! ChoiceCellView
        cell.voteDelegate = self
        
        if let question = question {
            cell.choice = question.choices[indexPath.item]
        }
        
        cell.backgroundColor = .blue
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 16, height: 50)
    }
    
}
