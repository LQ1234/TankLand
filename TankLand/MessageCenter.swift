//
//  MessageCenter.swift
//  TankLand
//
//  Created by larry qiu on 5/5/20.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation

struct MessageCenter {
    static var messages:[String:String]=[:]
    static func clear(){
        messages=[:]
    }
    static func sendMessage(id: String, message: String){
        messages[id]=message
    }
    
    static func receiveMessage(id: String)->String?{
        return(messages[id])
    }
}
