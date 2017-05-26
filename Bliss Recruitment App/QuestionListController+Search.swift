//
//  QuestionListController+Search.swift
//  Bliss Recruitment App
//
//  Created by Luís Machado on 26/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

extension QuestionListController {
    
    func handleSearch() {
        questionsSearched.removeAll()
        offsetToRequestSearch = 0
        fetchSearchQuestions()
    }
    
    func handleToggleSearch(newFilterApplied: Bool = false) {
        
        if let collectionView = collectionView {
            
            var insetValue: CGFloat = 50
            if searchOpen {
                insetValue = -50
                dismissKeyboard()
                
                searchView.shareButton.isEnabled = false
                
                let scrollToTop = searchPerformed
                searchPerformed = false
                
                collectionView.reloadData()
                
                if scrollToTop && self.questions.count > 0 {
                    self.collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                }
                
            }
            
            searchOpen = !searchOpen
            
            if self.searchOpen {
                self.navigationItem.rightBarButtonItem = self.closeSearchBarButton
            } else {
                self.navigationItem.rightBarButtonItem = self.openSearchBarButton
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                collectionView.frame = CGRect(x: collectionView.frame.minX, y: collectionView.frame.minY + insetValue, width: collectionView.frame.width, height: collectionView.frame.height)
                collectionView.contentInset = UIEdgeInsets(top: collectionView.contentInset.top, left: collectionView.contentInset.left, bottom: collectionView.contentInset.bottom + insetValue, right: collectionView.contentInset.right)
                collectionView.scrollIndicatorInsets = UIEdgeInsets(top: collectionView.scrollIndicatorInsets.top, left: collectionView.scrollIndicatorInsets.left, bottom: collectionView.scrollIndicatorInsets.bottom + insetValue, right: collectionView.scrollIndicatorInsets.right)
                collectionView.collectionViewLayout.invalidateLayout()
                
                self.searchView.frame = CGRect(x: self.searchView.frame.minX, y: self.searchView.frame.minY + insetValue, width: self.searchView.frame.width, height: self.searchView.frame.height)
            }, completion: { (success) in
                if !self.searchOpen {
                    self.searchView.inputTextField.text = ""
                }
                
            })
        }
    }

    
}
