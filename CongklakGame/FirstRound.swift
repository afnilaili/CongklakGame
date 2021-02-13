//
//  FirstRound.swift
//  CongklakGame
//
//  Created by Afni Laili on 13/02/21.
//

import UIKit

extension CongklakController {
    
    func isLastSheeld(index: Int) {
            //CEK APAKAH DI STOREHOUSE MILIK SENDIRI
            if (index == 7 && screenView.currentPlayer == .player1) || (index == 15 && screenView.currentPlayer == .player2){
                screenView.holes[index] += 1
                shellsInHand -= 1
                totalSteps = 0 // CURRENT PLAYER GET ANOTHER TURN
                screenView.playerTurnLabel.text = "Sheelds in hands : \(shellsInHand)"
                determineTheWinner()
                updateNumberOfSheelds(index: index)
                unlockButton()
                timer?.invalidate()
            }

            // KETIKA BUKAN DI STOREHOUSE
            if index != 7 && index != 15 {
                // CEK APAKAH ADA SHEELDS DI CURRENTHOLE
                if screenView.holes[index] != 0 {
                    shellsInHand = screenView.holes[index]+1
                    screenView.holes[index] = 0
                }
                else {
                    screenView.holes[index] += 1
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
            if isNgacang {
                if !ngacangs.contains(oppositeIndex), screenView.holes[oppositeIndex] != 0 {
                    updateAfterTembak(index: index, oppositeIndex: oppositeIndex)
                }
            }
            else {
                if screenView.holes[oppositeIndex] != 0 {
                    updateAfterTembak(index: index, oppositeIndex: oppositeIndex)
                }
            }
            updateNumberOfSheelds(index: index)
            screenView.playerTurnLabel.text = "Sheelds in hands : \(shellsInHand)"
        }
    }
       
       func switchTurn() {
           if screenView.currentPlayer == .player1 {
               screenView.currentPlayer = .player2
           }
           else if screenView.currentPlayer == .player2{
               screenView.currentPlayer = .player1
           }
           totalSteps = 0
           screenView.playerTurnLabel.text = "\(screenView.currentPlayer.rawValue)'s turn"
            screenView.lockButton()
       }
    
}
