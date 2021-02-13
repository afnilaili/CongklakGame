//
//  SecondRound.swift
//  CongklakGame
//
//  Created by Afni Laili on 13/02/21.
//

import UIKit

extension CongklakController {
    
    func isAnyLeftoverShellds(storeHouse: Int, smallestIndex: Int) {
        var leftover = 0
        var ngacang = 0
        var numberOfOpponentShells = 0
        var remainingShells = 0
        
        // CEK IF PLAYER MENANG BIJI
        if screenView.holes[storeHouse] > 49 {
            leftover = screenView.holes[storeHouse] - 49
            screenView.holes = [0,0,0,0,0,14,0,0,7,7,7,7,7,7,7,0]
            
//            for i in smallestIndex..<storeHouse {
//                // PLAYER'S SIDE - RECOUNTS THE SHELLS INTO EACH HOLE
//                screenView.holes[i] = 7
//                screenView.holes[storeHouse] = leftover
//                print(screenView.holes)
//            }
            
            // OPPONENT'S SIDE - RECOUNTS THE SHELLS INTO EACH HOLE
            numberOfOpponentShells = 49 - leftover
            ngacang = 7 - numberOfOpponentShells/7
            print(ngacang)
            
            if ngacang <= 3 {
                if numberOfOpponentShells % 7 != 0 {
                    remainingShells = leftover % 7
                    // FILL LOSER'S HOLE
                    fillLoserHole(leftover: leftover, ngacang: ngacang, numberOfOpponent: numberOfOpponentShells, remainingShells: remainingShells)
                }
                else {
                    ngacang += 1
                    remainingShells = 7
                    // FILL LOSER'S HOLE
                    fillLoserHole(leftover: leftover, ngacang: ngacang, numberOfOpponent: numberOfOpponentShells, remainingShells: remainingShells)
                }
            }
            else {
                screenView.playerTurnLabel.text = "Game is End, Ngacang's Hole is More Than 3"
            }
        }
        
        else if screenView.holes[storeHouse] == 49 {
            screenView.fillHoles()
        }
    }
    
    
    func fillLoserHole(leftover: Int, ngacang: Int, numberOfOpponent: Int, remainingShells: Int) {
        var largestIndex = Int()
        var smallestIndex = Int()
        var lastIndex = Int()
        var storeHouse = Int()
        
        // CEK WHO'S THE WINNER
        if screenView.currentPlayer == .player1 {
            largestIndex = 14
            smallestIndex = 8
            lastIndex = 7+ngacang
            storeHouse = 15
        }
        else if screenView.currentPlayer == .player2 {
            largestIndex = 6
            smallestIndex = 0
            lastIndex = ngacang - 1
            storeHouse = 7
        }
        
        // FILL LOSER'S HOLE
        screenView.holes[storeHouse] = 0
        
        for i in stride(from: largestIndex, through: lastIndex, by: -1) {
            screenView.holes[i] = 7
        }
        
        for i in stride(from: lastIndex, through: smallestIndex, by: -1) {
            let a = remainingShells/ngacang
            if a * ngacang == remainingShells {
                screenView.holes[i] = a
            }
            else {
                if i == smallestIndex {
                    screenView.holes[i] = remainingShells - a
                }
                else {
                    screenView.holes[i] = a
                }
            }
            ngacangs.insert(i, at: 0)
            updateUINgacang(index: i)
            
        }
    }
    
    func skipNgacang(index: Int) -> Int {
        var index: Int = index
        if screenView.currentPlayer == ngacangPlayer {
            if isNgacang {
                for i in ngacangs {
                    if screenView.currentPlayer == .player2 && index == 16 {
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
    
    func updateUINgacang(index: Int) {
        screenView.buttons[index].backgroundColor = .yellow
        screenView.buttons[index].setTitleColor(.black, for: .normal)
        isNgacang = true
        ngacangPlayer = screenView.currentPlayer
    }
    
}
