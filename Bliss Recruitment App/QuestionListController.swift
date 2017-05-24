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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Bliss Recruitment App"
        collectionView?.backgroundColor = .yellow
        collectionView?.register(QuestionListCellView.self, forCellWithReuseIdentifier: questionCellId)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: questionCellId, for: indexPath)
        //cell.backgroundColor = .blue
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: 70)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("clicked")
        
        let questionDetailController = QuestionDetailController()
        navigationController?.pushViewController(questionDetailController, animated: true)
    }
}

