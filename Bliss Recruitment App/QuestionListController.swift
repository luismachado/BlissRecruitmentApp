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
    var questionsSearched:[Question] = [Question]()
    var disconnectedController:DisconnectedController?
    
    let questionPerRequest:Int = 10
    var offsetToRequest = 0
    var offsetToRequestSearch = 0
    
    lazy var searchView: SearchBarView = {
        let view = SearchBarView(frame: CGRect(x: 0, y: -50, width: self.view.frame.size.width, height: 50))
        view.questionListController = self
        view.backgroundColor = UIColor(red: 234/255, green: 0, blue: 0, alpha: 1)
        view.alpha = 1
        return view
    }()
    
    var searchOpen: Bool = false
    var searchPerformed:Bool = false
    var openSearchBarButton: UIBarButtonItem?
    var closeSearchBarButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
        // get rid of black bar underneath navbar
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 234/255, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationController!.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white]
        navigationItem.title = "Bliss Recruitment App"
        collectionView?.backgroundColor = .yellow
        collectionView?.register(QuestionListCellView.self, forCellWithReuseIdentifier: questionCellId)

        openSearchBarButton = UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: #selector(handleToggleSearch))
        closeSearchBarButton = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(handleToggleSearch))
        
        navigationItem.rightBarButtonItem = openSearchBarButton
        self.view.addSubview(searchView)
        
        fetchQuestions()
    }
    
    func networkStatusChanged(_ notification: Notification) {        
        let status = Reach().connectionStatus()
        
        switch status {
        case .unknown, .offline:
            if disconnectedController == nil {
                disconnectedController = DisconnectedController()
                present(disconnectedController!, animated: true, completion: nil)
            }
        default:
            if let disconnectedController = disconnectedController {
                disconnectedController.regainedConnectivity {
                    self.disconnectedController = nil
                }
            }
        
        }
    }
    
    func dismissKeyboard() {
        searchView.dismissKeyboard()
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
                self.searchView.inputTextField.text = ""
            })
        }
    }
    
    fileprivate func fetchQuestions() {
        
        BlissAPI.shared.obtainAllQuestions(limit: questionPerRequest, offset: offsetToRequest * questionPerRequest, filter: nil, completion: { (questions) in
            self.questions.append(contentsOf: questions)
            self.collectionView?.reloadData()
            self.offsetToRequest += 1 // if maybe server returns 0 questions dont increase and stop future requests
        }) { (error) in
            print(error)
        }
    }
    
    func fetchSearchQuestions() {
        
        let searchTerm = searchView.inputTextField.text
        
        BlissAPI.shared.obtainAllQuestions(limit: questionPerRequest, offset: offsetToRequestSearch * questionPerRequest, filter: searchTerm, completion: { (questions) in
            self.searchPerformed = true
            self.searchView.shareButton.isEnabled = self.searchPerformed
            self.questionsSearched.append(contentsOf: questions)
            self.collectionView?.reloadData()
            
            if self.offsetToRequestSearch == 0 && self.questionsSearched.count > 0 {
                self.collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
            
            self.offsetToRequestSearch += 1 // if maybe server returns 0 questions dont increase and stop future requests
        }) { (error) in
            print(error)
        }
        
        
    }
    
    func handleShare(searchTerm:String) {
        let url = "blissrecruitment://questions?question_filter=\(searchTerm)"
        let shareController = ShareController()
        shareController.url.text = url
        navigationController?.pushViewController(shareController, animated: true)
        
    }
    
    func handleSearch() {
        
        //let indexPath = IndexPath(item: 0, section: 0)
        //collectionView?.scrollToItem(at: indexPath, at: .top, animated: false)
        questionsSearched.removeAll()
        
        offsetToRequestSearch = 0
//        if searchView.inputTextField.text == "" {
//            searchPerformed = false
//            searchView.shareButton.isEnabled = self.searchPerformed
//            collectionView?.reloadData()
//        } else {
            fetchSearchQuestions()
//        }
        
        
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
            //cell.questionText.text = "search \(indexPath.item)"
            
            // download more if penultimate cell is shown
            if indexPath.item == questionsSearched.count - 2 {
                print("download more search")
                fetchSearchQuestions()
            }

        } else {
                    cell.question = questions[indexPath.item]
            //cell.questionText.text = "normal \(indexPath.item)"
                    // download more if penultimate cell is shown
                    if indexPath.item == questions.count - 2 {
                        print("download more")
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
        
        BlissAPI.shared.obtainQuestionBy(id: id, completion: { (question) in
            let questionDetailController = QuestionDetailController()
            questionDetailController.question = question
            self.navigationController?.pushViewController(questionDetailController, animated: true)
        }) { (error) in
            print(error) //TODO AlertController
        }
    }
}

