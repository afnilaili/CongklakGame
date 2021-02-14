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
        if screenView.holes[0] == 0, screenView.holes[1] == 0, screenView.holes[2] == 0, screenView.holes[3] == 0, screenView.holes[4] == 0, screenView.holes[5] == 0, screenView.holes[6] == 0 {
            screenView.playerTurnLabel.text = "PLAYER 2 WIN 🎉"
            screenView.currentPlayer = .player2
            gotTheWinner = true
            // SECOND ROUND
            for i in 8...14 {
                // MENGOSONGI SEMUA HOLE, SHELLS DITARIK KE STORE HOUSE SEMUA
                screenView.holes[15] += screenView.holes[i]
                screenView.holes[i] = 0
            }
            // CEK APAKAH PLAYER 2 KELEBIHAN BIJI
            isAnyLeftoverShellds(storeHouse: 15, smallestIndex: 8)
        }
        
        // FIRST ROUND - IF PLAYER 2 RUNS OUT OF SHEELD ON HIS SIDE OF THE BOARD
        else if screenView.holes[8] == 0, screenView.holes[9] == 0, screenView.holes[10] == 0, screenView.holes[11] == 0, screenView.holes[12] == 0, screenView.holes[13] == 0, screenView.holes[14] == 0 {
            screenView.playerTurnLabel.text = "PLAYER 1 WIN 🎉"
            screenView.currentPlayer = .player1
            gotTheWinner = true
            // SECOND ROUND
            for i in 0...6 {
                screenView.holes[7] += screenView.holes[i]
                screenView.holes[i] = 0
            }
            // CEK APAKAH PLAYER 1 KELEBIHAN BIJI
            isAnyLeftoverShellds(storeHouse: 7, smallestIndex: 0)
        }
    }
}
