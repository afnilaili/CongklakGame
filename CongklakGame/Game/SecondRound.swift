//
//  SecondRound.swift
//  CongklakGame
//
//  Created by Afni Laili on 13/02/21.
//

import UIKit

extension CongklakController {
    
    //MARK: - RECOUNTS The 7 SHELLS INTO EACH HOLE
    //MARK: Starting with the hole nearest player own store house
    
    func isAnyLeftoverShellds(storeHouse: Int, smallestIndex: Int) {
        var leftover = 0
        var ngacang = 0
        var numberOfOpponentShells = 0
        var remainingShells = 0
        
        // CEK IF PLAYER MENANG BIJI
        if holes[storeHouse] > 49 {
            leftover = holes[storeHouse] - 49
            // PLAYER'S SIDE - RECOUNTS THE SHELLS INTO EACH HOLE
            for i in smallestIndex..<storeHouse {
                holes[i] = 7
                holes[storeHouse] = leftover
                print(holes)
            }
            // OPPONENT'S SIDE - RECOUNTS THE SHELLS INTO EACH HOLE
            numberOfOpponentShells = 49 - leftover
            ngacang = 7 - numberOfOpponentShells/7
            
            // PASTIKAN NGACANG HOLES TIDAK BOLEH LEBIH DARI 3
            if ngacang <= 3 {
                // PASTIKAN ADA BIJI YANG ADA UNTUK DIBAGI KE NGACANG HOLES
                if numberOfOpponentShells % 7 != 0 {
                    remainingShells = leftover % 7
                    // FILL LOSER'S HOLE
                    fillLoserHole(leftover: leftover, ngacang: ngacang, numberOfOpponent: numberOfOpponentShells, remainingShells: remainingShells)
                }
                // TIDAK ADA BIJI YANG ADA UNTUK DIBAGI KE NGACANG HOLES
                else {
                    ngacang += 1
                    if ngacang > 3 {
                        gameOver()
                        fillLoserHole(leftover: leftover, ngacang: ngacang, numberOfOpponent: numberOfOpponentShells, remainingShells: remainingShells)
                    }
                    else {
                        remainingShells = 7
                        // FILL LOSER'S HOLE
                        fillLoserHole(leftover: leftover, ngacang: ngacang, numberOfOpponent: numberOfOpponentShells, remainingShells: remainingShells)
                    }
                }
            }
            else {
                gameOver()
                fillLoserHole(leftover: leftover, ngacang: ngacang, numberOfOpponent: numberOfOpponentShells, remainingShells: remainingShells)
            }
        }
        
        else if holes[storeHouse] == 49 {
            fillHoles()
        }
    }
    
    func fillLoserHole(leftover: Int, ngacang: Int, numberOfOpponent: Int, remainingShells: Int) {
        var largestIndex = Int()
        var smallestIndex = Int()
        var lastIndex = Int()
        var storeHouse = Int()
        
        // CEK WHO'S THE WINNER
        if screenView.currentPlayer == .player1_Blue {
            largestIndex = 14
            smallestIndex = 8
            lastIndex = 7+ngacang
            storeHouse = 15
        }
        else if screenView.currentPlayer == .player2_Red {
            largestIndex = 6
            smallestIndex = 0
            lastIndex = ngacang - 1
            storeHouse = 7
        }
        
        // FILL LOSER'S HOLE
        holes[storeHouse] = 0
        
        for i in stride(from: largestIndex, through: lastIndex, by: -1) {
            holes[i] = 7
        }
        
        for i in stride(from: lastIndex, through: smallestIndex, by: -1) {
            let a = remainingShells/ngacang
            if a * ngacang == remainingShells {
                holes[i] = a
            }
            else {
                if i == smallestIndex {
                    holes[i] = remainingShells - a
                }
                else {
                    holes[i] = a
                }
            }
            ngacangs.insert(i, at: 0)
            updateUINgacang(index: i)
            
        }
    }
    
    // MARK: - NGACANG HOLES BECOME PROTECTED FROM OPPONENT
    
    func skipNgacang(index: Int) -> Int {
        var index: Int = index
        if screenView.currentPlayer == ngacangPlayer {
            if isNgacang {
                for i in ngacangs {
                    if screenView.currentPlayer == .player2_Red && index == 16 {
                        index =  0
                    }
                    if index == i {
                        index += 1
                    }
                }
            }
        }
        return index
    }
    
    // NGACANG HOLES BERUBAH WARNA
    func updateUINgacang(index: Int) {
        screenView.buttons[index].backgroundColor = .lightGray
        screenView.buttons[index].setTitleColor(.black, for: .normal)
        isNgacang = true
        ngacangPlayer = screenView.currentPlayer
    }
    
    //MARK: - NGACANG HOLES > 3
    
    func gameOver() {
        isGameOver = true
        shellsInHand = 0 // Stop Game
        screenView.decideTurnButton.setTitle("Continue", for: .normal)
        screenView.decideTurnButton.alpha = 1
        screenView.playerTurnLabel.text = "Game Over, \(screenView.currentPlayer.rawValue) Win"
    }

    
}
