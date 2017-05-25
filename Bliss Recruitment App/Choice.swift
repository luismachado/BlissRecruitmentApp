//
//  Choice.swift
//  Bliss Recruitment App
//
//  Created by Luís Machado on 25/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import Foundation

struct Choice {
    var name:String
    var votes:Int
    
    init(json:[String:Any]) {
        self.name = json["choice"] as? String ?? ""
        self.votes = json["votes"] as? Int ?? 0
    }
}
