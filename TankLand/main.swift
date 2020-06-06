//
//  main.swift
//  TankLand
//
//  Created by larry qiu on 5/5/20.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation

class LTank: Tank{
    let numberCols=15, numberRows=15;
    var step=1;
    static let directions=[
         Direction.North,
         Direction.NorthEast,
         Direction.East,
         Direction.SouthEast,
         Direction.South,
         Direction.SouthWest,
         Direction.West,
         Direction.NorthWest
    ]
    func asVec(_ d:Direction) -> Position{
        switch(d){
        case .North:
            return(Position(row:1,col:0))
        case .NorthEast:
            return(Position(row:1,col:1))
        case .East:
            return(Position(row:0,col:1))
        case .SouthEast:
            return(Position(row:-1,col:1))
        case .South:
            return(Position(row:-1,col:0))
        case .SouthWest:
            return(Position(row:-1,col:-1))
        case .West:
            return(Position(row:0,col:-1))
        case .NorthWest:
            return(Position(row:1,col:-1))
        }
    }
    struct CasheGO{
        let position:Position
        let energy:Int
        let id:String
        let isFriendly:Bool
        let stepScanned:Int
    }
    private static func distancesq(_ p1: Position, _ p2: Position)->Int{
        return((p1.row-p2.row)*(p1.row-p2.row)+(p1.col-p2.col)*(p1.col-p2.col))
    }
    private func colDmg(_ p: Position)->Bool{
        for row in p.row-1...p.row+1 {
            for col in p.col-1...p.col+1 {
                if(row>=15||col>=15||row<0||col<0){
                    continue;
                }
                if let go = radarCashe[row][col]{
                    if(go.isFriendly){
                        return(true)
                    }
                }
            }
        }
        return false
    }
    var radarCashe:[[CasheGO?]];
    private func processRadarScan(){
        if let radarResults=radarResults{
            for rr in radarResults{
                radarCashe[rr.position.row][rr.position.col]=CasheGO(position: rr.position, energy: rr.energy, id: rr.id, isFriendly: (rr.position.row==self.position.row&&rr.position.col==self.position.col), stepScanned: step)
            }
        }
    }
    private func calculateMissilePosition()->Position?{
        var numberOfPossibleEnemyTanks=0;
        for row in 0..<15 {
            for col in 0..<15 {
                if let go = radarCashe[row][col]{
                    if(go.energy>Constants.initialTankEnergy/3 && go.isFriendly==false){
                        numberOfPossibleEnemyTanks+=1;
                    }
                }
            }
        }
        if(numberOfPossibleEnemyTanks<2){//play offensive
            var resPos:Position?=nil;
            var maxValue:Float = -100000
            for row in 0..<15 {
                for col in 0..<15 {
                    if let go = radarCashe[row][col]{
                        if(go.isFriendly==false && !(colDmg(go.position))){
                            let value = Float(go.energy)/(sqrt(Float(LTank.distancesq(position,go.position)))+5)
                            if(value>maxValue){
                                maxValue=value
                                resPos=go.position
                            }
                        }
                    }
                }
            }
            return(resPos)
        }
        return(nil)
        
    }
    private func calculateMovePos()->(direction:Direction,distance:Int)?{
        var resPos:(direction:Direction,distance:Int)?=(direction:LTank.directions.randomElement()!,distance:1);
        var maxValue:Float = -10.0
        var closeGOs:[Position]=[]
        for row in position.row-1...position.row+1 {
            for col in position.col-1...position.col+1 {
                if(row>=15||col>=15||row<0||col<0){
                    continue;
                }
                if let go = radarCashe[row][col]{
                    if(!go.isFriendly){
                        closeGOs.append(go.position)
                    }
                }
            }
        }
        for direction in LTank.directions{
            for distance in 1...3{
                var value:Float=0
                let asvec = asVec(direction)
                let position = Position(row: asvec.row*distance, col: asvec.col*distance)
                if(position.row>=15||position.col>=15||position.row<0||position.col<0){
                    continue;
                }
                for p in closeGOs{
                    value-=sqrt(Float(LTank.distancesq(position,p)));
                }
                value -= Float(distance)
                
                if(value>maxValue){
                    maxValue=value
                    resPos=(direction:direction,distance:distance)
                }
            }
        }
        //print(resPos)
        return(resPos)
    }
    override init(row: Int, col: Int, name: String, energy: Int, instructions: String) {
        radarCashe = Array(repeating: Array(repeating: nil, count: numberCols), count: numberRows)
        super.init(row: row, col: col, name: name, energy: energy, instructions: instructions)
    }
    override func computePreActions() {
        step+=1;
        let scan=RunRadarAction(radius: 3)
        addPreAction(preAction:scan)
    }

    override func computePostActions() {
        processRadarScan()
        let mm=calculateMovePos();
        if let mm=mm{
            let moveAction=MoveAction(distance: mm.distance, direction: mm.direction)
            addPostAction(postAction: moveAction)
        }
        let pp=calculateMissilePosition();
        if let pp=pp{
            if(energy>Constants.initialTankEnergy/10){
                let mis=FireMissileAction(energyGiven: Constants.initialTankEnergy/5, destination: pp)
                addPostAction(postAction: mis)
            }
        }
        
    }
}


class FTank: Tank{
    override func computePreActions() {
        /*
        let scan=RunRadarAction(radius: 2)
        addPreAction(preAction:scan)
        */
        //addPreAction(preAction:SendMessageAction( message: "asp"))
        //addPreAction(preAction:ReceiveMessageAction())
        //addPreAction(preAction: SetShieldsAction(energyGiven: 500))
    }

    override func computePostActions() {
        //print("\(self.id) radar results: \(self.radarResults)")
        /*
        let moveAction=MoveAction(distance: 2, direction: getRandomDirection())
        addPostAction(postAction: moveAction)
        if let pos=self.radarResults?.shuffled().first?.position{
            let mis=FireMissileAction(energyGiven: 1000, destination: pos)
            addPostAction(postAction: mis)

        }
        */
        /*
        if(Bool.random()){
            let drop=DropMineAction(energyGiven: 1000, dropDirection: getRandomDirection())
            addPostAction(postAction: drop)

        }else{
            let drop=DropRoverAction(energyGiven: 1000, dropDirection: getRandomDirection(), directionGiven: Bool.random() ? getRandomDirection() : nil)
            addPostAction(postAction: drop)
        }*/
        
    }
}
var goodWins=0;
var badWins=0
while(true){
    let k=TankWorld(numberCols: 15, numberRows: 15);

    k.populateTankWorld()
    k.driver();
    if(k.lastLivingTank is LTank){
        goodWins+=1
    }else{
        badWins+=1
    }
    print("goodWins: \(goodWins) badWins: \(badWins)")
}
