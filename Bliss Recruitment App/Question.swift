//
//  Question.swift
//  Bliss Recruitment App
//
//  Created by Luís Machado on 25/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import Foundation

struct Question {
    var id:Int
    var imageUrl:String
    var thumbUrl:String
    var publishedAt:Date
    var question:String
    var choices:[Choice]
    
    static let dateFormat:String = "yyyy-MM-dd'T'HH:mm:SS.SSSZ"
    
    init(json:[String:Any]) {
        self.id = json["id"] as? Int ?? 0
        self.imageUrl = json["image_url"] as? String ?? ""
        self.thumbUrl = json["thumb_url"] as? String ?? ""
        self.question = json["question"] as? String ?? ""
        
        self.choices = [Choice]()
        if let jsonChoices = json["choices"] as? Array<[String:Any]> {
            for jsonChoice in jsonChoices {
                choices.append(Choice(json: jsonChoice))
            }
            
        }
        
        self.publishedAt = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Question.dateFormat
        if let date = dateFormatter.date(from: json["date"] as? String ?? "") {
            self.publishedAt = date
        }
    }
}
