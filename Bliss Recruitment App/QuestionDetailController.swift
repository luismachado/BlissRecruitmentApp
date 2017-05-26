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
            if let question = question {
                questionName.text = question.question

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = Question.presentationFormat
                datePublished.text = "(Published in: \(dateFormatter.string(from: question.publishedAt)))"
           
                
                thumbnail.loadImageUsingUrlString(urlString: question.imageUrl, completion: {
                    self.updateThumbnailSizeFor(frameSize: self.view.frame.size)
                })
                
                choicesCollectionView.reloadData()
            }
        }
    }
    
    private func updateThumbnailSizeFor(frameSize: CGSize) {
        var height = defaultThumbnailHeight
        thumbnailWidthAnchor?.constant = -16
        
        if let image = thumbnail.image {
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
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let questionName: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.backgroundColor = .gray
        return label
    }()
    
    let datePublished: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
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
        
        navigationItem.title = "Question"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(sharePressed))
        
        setup()

        choicesCollectionView.delegate = self
        choicesCollectionView.dataSource = self
        choicesCollectionView.register(ChoiceCellView.self, forCellWithReuseIdentifier: "choiceCellId")
        
    }
    
    @objc private func sharePressed() {
        
        guard let questionId = question?.id else { return }
        
        let url = "blissrecruitment://questions?question_id=\(questionId)"
        let shareController = ShareController()
        shareController.url.text = url
        navigationController?.pushViewController(shareController, animated: true)
    }
    
    func setup() {
        view.addSubview(thumbnail)
        thumbnail.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8).isActive = true
        thumbnail.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        thumbnailWidthAnchor = thumbnail.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16)
        thumbnailWidthAnchor?.isActive = true
        thumbnailHeightAnchor = thumbnail.heightAnchor.constraint(equalToConstant: defaultThumbnailHeight)
        thumbnailHeightAnchor?.isActive = true
        
        view.addSubview(questionName)
        questionName.anchor(top: thumbnail.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 26)
        
        view.addSubview(datePublished)
        datePublished.anchor(top: questionName.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 26)
        
        view.addSubview(choicesCollectionView)
        choicesCollectionView.anchor(top: datePublished.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
    }
    
    func votedOn(selectedChoice: Choice) {
        let idx = question?.choices.index { (choice) -> Bool in
            choice.name == selectedChoice.name && choice.votes == selectedChoice.votes
        }
        
        guard let questionIndex = idx else {return}
        
        question?.choices[questionIndex].votes += 1
        guard let question = question else { return }
        
        BlissAPI.shared.updateQuestion(question: question, completion: { (question) in
            self.question = question
        }) { (error) in
            //TODO SHOW ALARM
            print(error)
        }
        
        
        print("Voted in \(selectedChoice.name)")
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
