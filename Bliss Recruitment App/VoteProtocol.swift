//
//  VoteProtocol.swift
//  Bliss Recruitment App
//
//  Created by Luís Machado on 25/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import Foundation

protocol VoteProtocol: class {
    
    func votedOn(selectedChoice: Choice)
}
