//
//  BlissApi.swift
//  Bliss Recruitment App
//
//  Created by Luís Machado on 24/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import Foundation
import Alamofire

//Singleton BlissAPI
class BlissAPI: NSObject {
    
    let stringUrl = "https://private-anon-f5f756918c-blissrecruitmentapi.apiary-mock.com/"

    static let shared:BlissAPI = BlissAPI()
    
    func checkHealth(success: @escaping () -> (),
                     failure: @escaping(Error) -> ()) {
        
        let requestUrl = stringUrl+"health"
        Alamofire.request(requestUrl).validate().responseJSON { (response) in
            print(response.result)
            switch response.result {
            case .success:
                success()
            case .failure(let error):
                failure(error)
            }
        }
    }

    func obtainAllQuestions(limit:Int, offset:Int, filter:String?,
                            completion: @escaping ([Question]) -> (),
                            failure: @escaping(Error) -> ()) {
        
        var filterString = ""
        if let filter = filter {
            filterString = "&\(filter)"
        }
        
        let requestUrl = stringUrl+"questions?\(limit)&\(offset)"+filterString
        print(requestUrl)
        Alamofire.request(requestUrl).validate().responseJSON { (response) in
            
            switch response.result {
            case .failure(let error):
                failure(error)
            case .success:
                guard let json = response.result.value as? Array<[String:Any]> else {
                    failure(NSError(domain: "Unable to retrieve questions.", code: -1, userInfo: nil))
                    return
                }
                var questions = [Question]()
                for question in json {
                    questions.append(Question(json: question))
                }
                
                completion(questions)
            }
        }
    }
    
    func obtainQuestionBy(id: Int,
                          completion: @escaping (Question) -> (),
                          failure: @escaping(Error) -> ()) {
        
        let requestUrl = stringUrl+"questions/\(id)"
        print(requestUrl)
        Alamofire.request(requestUrl).validate().responseJSON { (response) in
            
            switch response.result {
            case .failure(let error):
                failure(error)
            case .success:
                guard let json = response.result.value as? [String:Any] else {
                    failure(NSError(domain: "Unable to retrieve question.", code: -1, userInfo: nil))
                    return
                }
                let question = Question(json: json)
                completion(question)
            }
        }
    }
    
    func updateQuestion(question: Question,
                        completion: @escaping (Question) -> (),
                        failure: @escaping(Error) -> ()) {
        
        let requestUrl = stringUrl+"questions/\(question.id)"
        let questionJson:Parameters = question.toJson()

        Alamofire.request(requestUrl, method: .put, parameters: questionJson, encoding: JSONEncoding.default).validate().responseJSON { (response) in

            switch response.result {
            case .failure(let error):
                failure(error)
            case .success:
                guard let json = response.result.value as? [String:Any] else {
                    failure(NSError(domain: "Unable to retrieve updated question.", code: -1, userInfo: nil))
                    return
                }
                let question = Question(json: json)
                completion(question)
            }
        }
    }
    
    func share(destinationEmail: String, contentUrl: String,
               success: @escaping () -> (),
               failure: @escaping(Error) -> ()) {
        
        let requestUrl = stringUrl+"share?\(destinationEmail)&\(contentUrl)"

        
        Alamofire.request(requestUrl, method: .post).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                success()
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    
}
