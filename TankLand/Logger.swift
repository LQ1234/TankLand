//
//  Logger.swift
//  TankLand
//
//  Created by larry qiu on 5/6/20.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation

struct Logger{
    let quiet=false
    var start=Date()
    func addLog(_ o:GameObject,_ str:String){
        //Date()
        if(!quiet){
            print("\((10.0*start.distance(to: Date())).rounded()/10.0) \(o) \(str)")

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
