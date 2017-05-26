//
//  ViewController.swift
//  Bliss Recruitment App
//
//  Created by Luís Machado on 24/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

let backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
let navigationColor = UIColor.rgb(red: 40, green: 43, blue: 52)

class QuestionListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let questionCellId = "questionCellId"
    var questions:[Question] = [Question]()
    var questionsSearched:[Question] = [Question]()
    var disconnectedController:DisconnectedController?
    
    let questionPerRequest:Int = 10
    var offsetToRequest = 0
    var offsetToRequestSearch = 0
    
    let spinner = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()
    
    lazy var searchView: SearchBarView = {
        let view = SearchBarView(frame: CGRect(x: 0, y: -50, width: self.view.frame.size.width, height: 50))
        view.questionListController = self
        view.backgroundColor = navigationColor
        view.alpha = 1
        return view
    }()
    
    var searchOpen: Bool = false
    var searchPerformed:Bool = false
    var spinningButton: UIBarButtonItem?
    var hiddenButton: UIBarButtonItem?
    var openSearchBarButton: UIBarButtonItem?
    var closeSearchBarButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        
        // Check if opened by url
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let url = appDelegate.urlDeepLink {
            fetchQuestions()
            openUrl(url: url)
        } else {
            let loadingController = LoadingController()
            loadingController.questionListController = self
            navigationController?.pushViewController(loadingController, animated: false)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(receivedNotificationUrl(_:)), name: NSNotification.Name("AppOpenedByUrlNotification"), object: nil)
        
        super.viewDidLoad()
        
        setupNavBar()
        setupCollectionView()
    }
    
    func startController() {
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        fetchQuestions()
    }
    
    private func setupNavBar() {
        // get rid of black bar underneath navbar
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = navigationColor
        navigationController?.navigationBar.tintColor = .white
        navigationController!.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white]

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 71, height: 26))
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "bliss_logo")
        
        self.navigationItem.titleView = imageView
        
        spinner.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        spinningButton = UIBarButtonItem(customView: spinner)
        hiddenButton = UIBarButtonItem(customView: UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))) //to keep logo always centered
        navigationItem.leftBarButtonItem = hiddenButton
        
        openSearchBarButton = UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: #selector(handleToggleSearch))
        closeSearchBarButton = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(handleToggleSearch))
        
        navigationItem.rightBarButtonItem = openSearchBarButton
        self.view.addSubview(searchView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func receivedNotificationUrl(_ notification: Notification) {
        if let url = notification.userInfo?["requestUrl"] as? String{
            openUrl(url: url)
        }
    }
    
    func refetchQuestions() {
        if searchOpen && searchPerformed {
            offsetToRequestSearch = 0
            fetchSearchQuestions()
        } else {
            offsetToRequest = 0
            fetchQuestions()
        }
    }
    
    func openUrl(url:String) {
        let request = url.replacingOccurrences(of: "blissrecruitment://questions?", with: "")

        var array = request.characters.split(separator: "=").map(String.init)
        
        if array.count > 0 {
            if array[0] == "question_id" && array.count == 2 {
                guard let questionId = Int(array[1]) else { return }
                if (navigationController?.topViewController as? QuestionDetailController) != nil {
                    _ = navigationController?.popViewController(animated: false)
                }
                openDetailQuestionFor(id: questionId)
            }
            if array[0] == "question_filter" {

                if (navigationController?.topViewController as? QuestionDetailController) != nil {
                    _ = navigationController?.popViewController(animated: false)
                }
                
                if !searchOpen {
                    handleToggleSearch()
                } else {
                    searchView.inputTextField.text = ""
                }
                
                if array.count == 1 {
                    // Show initial list or show as is?
                } else if array.count == 2 {
                    print("Searching for: \(array[1])")
                    searchView.inputTextField.text = array[1]
                    searchView.handleSearch()
                }
            }
        }
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
    
    func startSpinner() {
        navigationItem.leftBarButtonItem = spinningButton
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        self.spinner.stopAnimating()
        self.refreshControl.endRefreshing()
        self.navigationItem.leftBarButtonItem = hiddenButton
    }
    
    func fetchQuestions() {
        startSpinner()
        BlissAPI.shared.obtainAllQuestions(limit: questionPerRequest, offset: offsetToRequest * questionPerRequest, filter: nil, completion: { (questions) in
            
            if self.offsetToRequest == 0 {
                self.questions =  questions
            } else {
               self.questions.append(contentsOf: questions)
            }
            
            self.stopSpinner()
            self.collectionView?.reloadData()
            self.offsetToRequest += 1 // if maybe server returns 0 questions dont increase and stop future requests
        }) { (error) in
            self.stopSpinner()
            AlertHelper.displayAlert(title: "Fetch Questions", message: "Unable to fetch questions. Please try again later.", displayTo: self)
            print(error)
        }
    }
    
    func fetchSearchQuestions() {
        startSpinner()
        let searchTerm = searchView.inputTextField.text
        let encodedSearchTerm = searchTerm?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        BlissAPI.shared.obtainAllQuestions(limit: questionPerRequest, offset: offsetToRequestSearch * questionPerRequest, filter: encodedSearchTerm, completion: { (questions) in
            
            if self.offsetToRequest == 0 {
                self.questionsSearched =  questions
            } else {
                self.questionsSearched.append(contentsOf: questions)
            }
            
            self.stopSpinner()
            self.searchPerformed = true
            self.searchView.shareButton.isEnabled = self.searchPerformed
            
            self.collectionView?.reloadData()
            
            if self.offsetToRequestSearch == 0 && self.questionsSearched.count > 0 {
                self.collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
            
            self.offsetToRequestSearch += 1 // if maybe server returns 0 questions dont increase and stop future requests
        }) { (error) in
            self.stopSpinner()
            AlertHelper.displayAlert(title: "Search", message: "Unable to search questions. Please try again later.", displayTo: self)
            print(error)
        }
        
        
    }
    
    func handleShare(searchTerm:String) {
        let url = "blissrecruitment://questions?question_filter=\(searchTerm)"
        let shareController = ShareController()
        shareController.url.text = url
        navigationController?.pushViewController(shareController, animated: true)
        
    }
        
    func openDetailQuestionFor(id: Int) {
        print("QuestionListController: opening question id:\(id)")
        
        startSpinner()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        BlissAPI.shared.obtainQuestionBy(id: id, completion: { (question) in
            UIApplication.shared.endIgnoringInteractionEvents()
            self.stopSpinner()
            let questionDetailController = QuestionDetailController()
            questionDetailController.question = question
            self.navigationController?.pushViewController(questionDetailController, animated: true)
        }) { (error) in
            UIApplication.shared.endIgnoringInteractionEvents()
            self.stopSpinner()
            AlertHelper.displayAlert(title: "Question", message: "Unable to retreive question. Please try again later.", displayTo: self)
            print(error)
        }
    }
}
