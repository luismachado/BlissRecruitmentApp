//
//  QuestionListController+CollectionView.swift
//  Bliss Recruitment App
//
//  Created by Luís Machado on 26/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

extension QuestionListController {
    
    func setupCollectionView() {
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = backgroundColor
        collectionView?.register(QuestionListCellView.self, forCellWithReuseIdentifier: questionCellId)
        
        let attributes = [ NSForegroundColorAttributeName : navigationColor ] as [String: Any]
        refreshControl.tintColor = navigationColor
        refreshControl.attributedTitle = NSAttributedString(string: "Refetching questions...", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(refetchQuestions), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            collectionView?.refreshControl = refreshControl
        } else {
            collectionView?.addSubview(refreshControl)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searchOpen && searchPerformed {
            return questionsSearched.count
        }
        
        return questions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: questionCellId, for: indexPath) as! QuestionListCellView
        
        if searchOpen && searchPerformed{
            cell.question = questionsSearched[indexPath.item]
            // download more if penultimate cell is shown
            if indexPath.item == questionsSearched.count - 1 {
                fetchSearchQuestions()
            }
            
        } else {
            cell.question = questions[indexPath.item]
            if indexPath.item == questions.count - 1 {
                fetchQuestions()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: 70)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Maybe use this question object instead of downloading it?
        let id = questions[indexPath.item].id
        openDetailQuestionFor(id: id)
    }
}
