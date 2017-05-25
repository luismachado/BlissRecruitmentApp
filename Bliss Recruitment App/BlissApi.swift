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

    func obtainAllQuestions(limit:Int, offset:Int, filter:String?,
                            completion: @escaping ([Question]) -> (),
                            fail: @escaping(Error) -> ()) {
        
        let filterString = filter != nil ? "&\(filter)" : ""
        let requestUrl = stringUrl+"questions?\(limit)&\(offset)"+filterString
        print(requestUrl)
        Alamofire.request(requestUrl).validate().responseJSON { (response) in
            if let error = response.error {
                fail(error)
                return
            }
            
            guard let json = response.result.value as? Array<[String:Any?]> else {
                fail(NSError(domain: "Unable to retrieve questions.", code: -1, userInfo: nil))
                return
            }
            var questions = [Question]()
            for question in json {
                questions.append(Question(json: question))
            }
            
            completion(questions)
        }
    }
    
    func obtainQuestionBy(id: Int,
                          completion: @escaping (Question) -> (),
                          fail: @escaping(Error) -> ()) {
        
        
    }

    
    
    
    
}
