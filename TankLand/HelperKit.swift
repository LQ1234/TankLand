//
//  HelperKit.swift
//  TankLand
//
//  Created by larry qiu on 5/7/20.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation

extension Position {
    init (position: Position, direction: Direction, magnitude: Int){
        let asvec=direction.asVec()
        self.init(row:position.row+asvec.row*magnitude,col:position.col+asvec.col*magnitude)
    }
    static func distancesq(_ p1: Position, _ p2: Position)->Int{
        return((p1.row-p2.row)*(p1.row-p2.row)+(p1.col-p2.col)*(p1.col-p2.col))
    }
    func distancesq(_ o:Position)->Int{
        return(Position.distancesq(self,o))
    }
}

extension TankWorld{
    func isGoodIndex(row: Int, col: Int)->Bool {
        return(row>=0&&col>=0&&row<self.numberRows&&col<self.numberCols)
    }
    func isValidPosition(_ position: Position)->Bool{
        return(self.isGoodIndex(row:position.row,col:position.col))
    }
    func isPositionEmpty(_ position: Position)->Bool{
        return(isValidPosition(position)&&self.grid[position.row][position.col]==nil)
    }
    func moveObject(_ go:GameObject,_ po:Position){
        precondition(isPositionEmpty(po))
        precondition(grid[go.position.row][go.position.col] === go)
        grid[go.position.row][go.position.col]=nil
        go.setPosition(newPosition: po)
        grid[go.position.row][go.position.col]=go
    }
    func findGameObjectsWithinRange(_ position: Position, range: Int)->[Position]{
        var ret:Set<Position>=[]
        for go in findAllGameObjects(){
            if(position.distancesq(go.position)<=range*range){
                ret.insert(go.position)
            }
        }
        return(Array(ret))
    }
    func findAllTanks()->[Tank] {
        return(findAllGameObjects().filter{$0.objectType == .Tank}.map{$0 as! Tank})
    }
    func findAllRovers()->[Mine]{
        return(findAllGameObjects().filter{$0.objectType == .Rover}.map{$0 as! Mine})
        
    }
    func findAllMines()->[Mine]{
        return(findAllGameObjects().filter{$0.objectType == .Mine}.map{$0 as! Mine})
    }
    func makeOffsetPosition(position: Position, offsetRow: Int, offsetCol: Int) -> Position? {
        let p=Position(row:position.row+offsetRow,col:position.col+offsetCol)
        if(isValidPosition(p)){
            return p
        }
        return nil
    }
    func getLegalSurroundingPositions(_ position: Position)->[Position] {
        var pp:[Position]=[]
        for col in position.col-1...position.col+1{
            for row in position.row-1...position.row+1{
                if(col==position.col&&row==position.row){
                    continue
                }
                let p=Position(row:row,col:col)
                if(isValidPosition(p)){
                    pp.append(p)
                }
            }
        }
        return(pp)
    }
    func findFreeAdjacent(_ position: Position)->Position? {
        return(getLegalSurroundingPositions(position).shuffled().first)
    }

    
    func findAllGameObjects()->[GameObject] {
        var ret:[GameObject]=[]
        for row in self.grid{
            for itemo in row{
                if let item=itemo{
                    ret.append(item)
                }
            }
        }
        return ret;
    }
    func findWinner()->Tank? {
        let tanks=findAllTanks()
        if(tanks.count>1){
            return(nil)
        }
        return(tanks.first)
    }
    func dealExplosionDamage(_ mine:Mine,_ go:GameObject){
        var dmg=mine.energy*Constants.mineStrikeMultiple
        mine.addEnergy(amount: -mine.energy)
        grid[mine.position.row][mine.position.col]=nil
        if(go.objectType == .Tank){
            let tank=go as!Tank
            if(tank.shields>dmg){
                tank.setShields(amount: tank.shields-dmg)
            }else{
                dmg-=tank.shields
                tank.setShields(amount: 0)
                go.addEnergy(amount: -dmg)
            }
            
        }else{
            go.addEnergy(amount: -dmg)
        }
        

    }
}
func isDead(_ gameObject: GameObject)->Bool{
    return(gameObject.energy<=0)
}

func randomizeGameObjects<T: GameObject>(gameObjects: [T])->[T]{
    return(gameObjects.shuffled())
}
func getRandomDirection()->Direction {
    return(Direction.random())
}
func isEnergyAvailable(_ gameObject: GameObject, amount: Int)->Bool {
    return(gameObject.energy>=amount)
}
func applyCost(_ gameObject: GameObject, amount: Int){
    gameObject.addEnergy(amount: -amount)
}
