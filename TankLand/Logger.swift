//
//  Logger.swift
//  TankLand
//
//  Created by larry qiu on 5/6/20.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation

struct Logger{
    let quiet=true
    var start=Date()
    func addLog(_ o:GameObject,_ str:String){
        //Date()
        if(!quiet){
            print("\(start.distance(to: Date()).rounded()) \(o) \(str)")

        }
    }
    func addMajorLog(_ o:GameObject,_ str:String){
        
        addLog(o,str)
    }
    func print(_ m:String){
        if(!quiet){
            Swift.print(m)
        }
    }
}
var logger=Logger()
