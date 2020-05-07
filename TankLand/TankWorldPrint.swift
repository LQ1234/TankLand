//
//  TankWorldPrint.swift
//  TankLand
//
//  Created by larry qiu on 5/5/20.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation

extension TankWorld {
    private func energyOrBlanks(gameObject: GameObject?) -> String {
        guard let go = gameObject else {
            return "       "
        }

        return fitI(go.energy, 7)
    }

    private func idOrBlanks(gameObject: GameObject?) -> String {
        guard let go = gameObject else {
            return "       "
        }

        return fit(go.id, 7)
    }

    private func positionOrBlanks(row: Int, col: Int, gameObject: GameObject?) -> String {
        if gameObject == nil {
            return "       "
        }

        return fit("(\(row),\(col))", 7)
    }

    func gridReport() -> String {
        var report1 = ""
        var report2 = ""
        var report3 = ""
        let gridLine = "|_______|________|________|________|________|________|________|________|________|________|________|________|________|________|________|\n"
        let topGridLine = "_______________________________________________________________________________________________________________________________________\n"
        var report = topGridLine
        for row in 0 ..< numberRows {
            report1 = "|"
            report2 = "|"
            report3 = "|"
            for col in 0 ..< numberCols {
                report1 += energyOrBlanks(gameObject: grid[row][col]) + "| "
                report2 += idOrBlanks(gameObject: grid[row][col]) + "| "
                report3 += positionOrBlanks(row: row, col: col, gameObject: grid[row][col]) + "| "
            }
            report += report1 + "\n" + report2 + "\n" + report3 + "\n" + gridLine
        }
        return report
    }
}
