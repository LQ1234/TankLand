//
//  Logger.swift
//  TankLand
//
//  Created by larry qiu on 5/6/20.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation

struct Logger{
    var start=Date()
    func addLog(_ o:GameObject,_ str:String){
        //Date()
        print("\(start.distance(to: Date()).rounded()) \(o) \(str)")
    }
    func addMajorLog(_ o:GameObject,_ str:String){
        addLog(o,str)
    }
}
var logger=Logger()
