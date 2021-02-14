//
//  FirstRound.swift
//  CongklakGame
//
//  Created by Afni Laili on 13/02/21.
//

import UIKit

extension CongklakController {
    
    func isSkipOpponentStoreHouse(index: Int) -> Int {
        var indx: Int!
        indx = index
        // SKIP STORE HOUSE LAWAN
        if indx == 15 && screenView.currentPlayer != .player2 {
            indx = 0
            return indx
        }
        // SKIP STORE HOUSE LAWAN
        else if indx == 7 && screenView.currentPlayer != .player1 {
            indx += 1
            return indx
        }
        else {
            return index
        }
    }
    
    func isLastSheeld(index: Int) {
            //CEK APAKAH DI STOREHOUSE MILIK SENDIRI
            if (index == 7 && screenView.currentPlayer == .player1) || (index == 15 && screenView.currentPlayer == .player2){
                screenView.holes[index] += 1
                shellsInHand -= 1
                totalSteps = 0 // CURRENT PLAYER GET ANOTHER TURN - RESTART TOTAL STEPS
                screenView.playerTurnLabel.text = "Shells in hands : \(shellsInHand)"
                determineTheWinner()
                updateNumberOfShells(index: index)
                unlockButton()
                timer?.invalidate()
            }

            // KETIKA BUKAN DI STOREHOUSE
            if index != 7 && index != 15 {
                // CEK APAKAH ADA SHELLS DI CURRENTHOLE
                if screenView.holes[index] != 0 {
                    // CEK APAKAH ADA NGACANG HOLES
                    if isNgacang {
                        // BUKAN DI NGACANG HOLES
                        if !ngacangs.contains(index) {
                            shellsInHand = screenView.holes[index]+1
                            screenView.holes[index] = 0
                        }
                        // CAN'T TAKE SHELLS FROM NGACANG HOLE
                        else {
                            shellsInHand -= 1
                            screenView.holes[index] += 1
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.6){
                                self.switchTurn()
                                self.unlockButton()
                            }
                        }
                    }
                    // BELUM ADA NGACANG HOLES
                    else {
                        shellsInHand = screenView.holes[index]+1
                        screenView.holes[index] = 0
                    }
                }
                // TIDAK ADA SHELLS DI CURRENTHOLE
                else {
                    screenView.holes[index] += 1
                    shellsInHand -= 1
                    tembak(index: index)
                    print(screenView.holes)
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.6){
                        self.switchTurn()
                        self.unlockButton()
                    }
                    determineTheWinner()
                    timer?.invalidate()
                }
            }
        }
    
    func updateAfterTembak(index: Int, oppositeIndex: Int) {
        if screenView.currentPlayer == .player1 {
            screenView.holes[7] += screenView.holes[oppositeIndex]+1
            screenView.holes[index] = 0
            screenView.holes[oppositeIndex] = 0
            
            screenView.buttons[oppositeIndex].alpha = 1
            screenView.buttons[7].alpha = 1
        }
        else {
            screenView.holes[15] += screenView.holes[oppositeIndex]+1
            screenView.holes[index] = 0
            screenView.holes[oppositeIndex] = 0
            
            screenView.buttons[oppositeIndex].alpha = 1
            screenView.buttons[15].alpha = 1
        }
    }
    
    func tembak(index: Int) {
        if totalSteps >= 15 { // UNTUK CEK SUDAH SATU PUTARAN/BLM
            let oppositeIndex = 14 - index
            // JIKA ADA NGACANG HOLES
            if isNgacang {
                // PASTIKAN CURRENT HOLE BUKAN NGACANG HOLES
                if !ngacangs.contains(oppositeIndex), screenView.holes[oppositeIndex] != 0 {
                    updateAfterTembak(index: index, oppositeIndex: oppositeIndex)
                }
            }
            // BELUM ADA NGACANG HOLES
            else {
                if screenView.holes[oppositeIndex] != 0 {
                    updateAfterTembak(index: index, oppositeIndex: oppositeIndex)
                }
            }
            updateNumberOfShells(index: index)
        }
    }
    
    func switchTurn() {
        if screenView.currentPlayer == .player1 {
            screenView.currentPlayer = .player2
        }
        else if screenView.currentPlayer == .player2 {
            screenView.currentPlayer = .player1
        }
        totalSteps = 0
        screenView.playerTurnLabel.text = "\(screenView.currentPlayer.rawValue)'s turn"
        screenView.lockButton()
    }
    
}
