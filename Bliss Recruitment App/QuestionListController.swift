//
//  ViewController.swift
//  Bliss Recruitment App
//
//  Created by Luís Machado on 24/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

class QuestionListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let questionCellId = "questionCellId"
    var questions:[Question] = [Question]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Bliss Recruitment App"
        collectionView?.backgroundColor = .yellow
        collectionView?.register(QuestionListCellView.self, forCellWithReuseIdentifier: questionCellId)

        fetchQuestions()
    }
    
    fileprivate func fetchQuestions() {
        
        
        BlissAPI.shared.obtainAllQuestions(limit: 5, offset: 0, filter: nil, completion: { (questions) in
            self.questions.append(contentsOf: questions)
            self.collectionView?.reloadData()
        }) { (error) in
            print(error)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: questionCellId, for: indexPath) as! QuestionListCellView
        cell.question = questions[indexPath.item]
        //cell.backgroundColor = .blue
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: 70)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Maybe use this question object instead of downloading it?
        let id = questions[indexPath.item].id
        
        BlissAPI.shared.obtainQuestionBy(id: id, completion: { (question) in
            let questionDetailController = QuestionDetailController()
            questionDetailController.question = question
            self.navigationController?.pushViewController(questionDetailController, animated: true)
        }) { (error) in
            print(error) //TODO AlertController
        }
    }
}

