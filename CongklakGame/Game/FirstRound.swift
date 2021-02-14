//
//  FirstRound.swift
//  CongklakGame
//
//  Created by Afni Laili on 13/02/21.
//

import UIKit

extension CongklakController {
    
    //MARK: - Skip Opponent Store house
    
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
    
    //MARK: - If the last hole into which player dropped a shell
    
    func isLastSheeld(index: Int) {
            //CEK APAKAH DI STOREHOUSE MILIK SENDIRI
            if (index == 7 && screenView.currentPlayer == .player1) || (index == 15 && screenView.currentPlayer == .player2){
                holes[index] += 1
                shellsInHand -= 1
                totalSteps = 0 // CURRENT PLAYER GET ANOTHER TURN - RESTART TOTAL STEPS
                screenView.playerTurnLabel.text = "Shells in hands : \(shellsInHand)"
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                    self.screenView.playerTurnLabel.text = "\(self.screenView.currentPlayer.rawValue)'s turn"
                }
                determineTheWinner()
                updateNumberOfShells(index: index)
                unlockButton()
                timer?.invalidate()
            }

            // KETIKA BUKAN DI STOREHOUSE
            if index != 7 && index != 15 {
                // CEK APAKAH ADA SHELLS DI CURRENTHOLE
                if holes[index] != 0 {
                    // CEK APAKAH ADA NGACANG HOLES
                    if isNgacang {
                        // BUKAN DI NGACANG HOLES
                        if !ngacangs.contains(index) {
                            shellsInHand = holes[index]+1
                            holes[index] = 0
                        }
                        // CAN'T TAKE SHELLS FROM NGACANG HOLE
                        else {
                            shellsInHand -= 1
                            holes[index] += 1
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.6){
                                self.switchTurn()
                                self.unlockButton()
                            }
                        }
                    }
                    // BELUM ADA NGACANG HOLES
                    else {
                        shellsInHand = holes[index]+1
                        holes[index] = 0
                    }
                }
                // TIDAK ADA SHELLS DI CURRENTHOLE
                else {
                    holes[index] += 1
                    shellsInHand -= 1
                    tembak(index: index)
                    print(holes)
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.6){
                        self.switchTurn()
                        self.unlockButton()
                    }
                    determineTheWinner()
                    timer?.invalidate()
                }
            }
        }
    
    //MARK: - do Tembak
    
    func tembak(index: Int) {
        if totalSteps >= 15 { // UNTUK CEK SUDAH SATU PUTARAN/BLM
            let oppositeIndex = 14 - index
            // JIKA ADA NGACANG HOLES
            if isNgacang {
                // PASTIKAN CURRENT HOLE BUKAN NGACANG HOLES
                if !ngacangs.contains(oppositeIndex), holes[oppositeIndex] != 0 {
                    updateAfterTembak(index: index, oppositeIndex: oppositeIndex)
                }
            }
            // BELUM ADA NGACANG HOLES
            else {
                if holes[oppositeIndex] != 0 {
                    updateAfterTembak(index: index, oppositeIndex: oppositeIndex)
                }
            }
            updateNumberOfShells(index: index)
        }
    }
    
    func updateAfterTembak(index: Int, oppositeIndex: Int) {
        if screenView.currentPlayer == .player1 {
            holes[7] += holes[oppositeIndex]+1
            holes[index] = 0
            holes[oppositeIndex] = 0
            
            screenView.buttons[oppositeIndex].alpha = 1
            screenView.buttons[7].alpha = 1
        }
        else {
            holes[15] += holes[oppositeIndex]+1
            holes[index] = 0
            holes[oppositeIndex] = 0
            
            screenView.buttons[oppositeIndex].alpha = 1
            screenView.buttons[15].alpha = 1
        }
    }
    
    //MARK: - Switch Player's Turn
    
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
