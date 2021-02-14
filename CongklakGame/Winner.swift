//
//  Winner.swift
//  CongklakGame
//
//  Created by Afni Laili on 13/02/21.
//

import UIKit

extension CongklakController {
    
    func determineTheWinner() {
        // FIRST ROUND - IF PLAYER 1 RUNS OUT OF SHEELD ON HIS SIDE OF THE BOARD
        if holes[0] == 0, holes[1] == 0, holes[2] == 0, holes[3] == 0, holes[4] == 0, holes[5] == 0, holes[6] == 0 {
            screenView.playerTurnLabel.text = "PLAYER 2 WIN 🎉"
            screenView.currentPlayer = .player2
            gotTheWinner = true
            // SECOND ROUND
            for i in 8...14 {
                // MENGOSONGI SEMUA HOLE, SHELLS DITARIK KE STORE HOUSE SEMUA
                holes[15] += holes[i]
                holes[i] = 0
            }
            // CEK APAKAH PLAYER 2 KELEBIHAN BIJI
            isAnyLeftoverShellds(storeHouse: 15, smallestIndex: 8)
        }
        
        // FIRST ROUND - IF PLAYER 2 RUNS OUT OF SHEELD ON HIS SIDE OF THE BOARD
        else if holes[8] == 0, holes[9] == 0, holes[10] == 0, holes[11] == 0, holes[12] == 0, holes[13] == 0, holes[14] == 0 {
            screenView.playerTurnLabel.text = "PLAYER 1 WIN 🎉"
            screenView.currentPlayer = .player1
            gotTheWinner = true
            // SECOND ROUND
            for i in 0...6 {
                holes[7] += holes[i]
                holes[i] = 0
            }
            // CEK APAKAH PLAYER 1 KELEBIHAN BIJI
            isAnyLeftoverShellds(storeHouse: 7, smallestIndex: 0)
        }
    }
}
