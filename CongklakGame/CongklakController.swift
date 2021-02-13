//
//  CongklakController.swift
//  CongklakGame
//
//  Created by Afni Laili on 12/02/21.
//

import UIKit

class CongklakController: ViewController<CongklakView> {
    
    var shellsInHand = Int()
    var timer: Timer?
    var previousIndex: Int!
    var totalSteps = 0
    var gotTheWinner = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.holeTapped = { [weak self] index in
            self?.startPlaying(pickedHole: index)
        }
    }
    
    func determineTheWinner() {
        // FIRST ROUND - IF PLAYER 1 RUNS OUT OF SHEELD ON HIS SIDE OF THE BOARD
        if screenView.holes[0] == 0, screenView.holes[1] == 0, screenView.holes[2] == 0, screenView.holes[3] == 0, screenView.holes[4] == 0, screenView.holes[5] == 0, screenView.holes[6] == 0 {
            screenView.playerTurnLabel.text = "PLAYER 2 WIN 🎉"
            screenView.currentPlayer = .player2
            gotTheWinner = true
            // SECOND ROUND
            for i in 8...14 {
                // MENGOSONGI SEMUA HOLE, SHEELDS DITARIK KE STORE HOUSE SEMUA
                screenView.holes[15] += screenView.holes[i]
                screenView.holes[i] = 0
            }
            // CEK APAKAH PLAYER 2 KELEBIHAN BIJI
            isAnyLeftoverShellds(storeHouse: 15, smallestIndex: 8)
            
            print(screenView.holes)
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
    
    // UNTUK CEK HOLE YANG DIPILIH APAKAH ADA ISINYA(TIDAK KOSONG)
    func isEmptyHole(index: Int) {
        if screenView.holes[index] == 0 {
            screenView.playerTurnLabel.text = "IT'S EMPTY. CHOOSE ANOTHER HOLE"
            screenView.unlockButton()
        }
    }
    
    func startPlaying(pickedHole: Int) {
        var index = pickedHole
        
        isEmptyHole(index: index)
        shellsInHand = screenView.holes[index]
        screenView.holes[index] = 0
        screenView.buttons[index].setTitle("\(screenView.holes[index])", for: .normal)
        index += 1
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true, block: { [self] timer in
            if shellsInHand > 0 {
                totalSteps += 1
                
                // CHECK IF THE HOLE IS THE LAST ELEMENT OF ARRAY
                if index > screenView.holes.count-1 {
                    index = 0
                }
                // SKIP STORE HOUSE LAWAN
                if index == 15 && screenView.currentPlayer != .player2 {
                    index = 0
                }
                // SKIP STORE HOUSE LAWAN
                if index == 7 && screenView.currentPlayer != .player1 {
                    index += 1
                }
                //UPDATE UI
                updateUI(index: index)
                
                // CEK IF SHELLS IN HAND SISA 1
                if shellsInHand == 1 {
                    isLastSheeld(index: index)
                }
                // SHEELDS MASIH ADA > 1
                else {
                    screenView.holes[index] += 1
                    shellsInHand -= 1
                }
                
                screenView.playerTurnLabel.text = "Sheelds in hands : \(shellsInHand)"
//                if gotTheWinner {
//                    determineTheWinner()
//                }
                updateNumberOfSheelds(index: index)
                print(screenView.holes)
                previousIndex = index
                index += 1
                
            } else {
                timer.invalidate()
            }
        })
    }
    
    func isLastSheeld(index: Int) {
        //CEK APAKAH DI STOREHOUSE MILIK SENDIRI
        if (index == 7 && screenView.currentPlayer == .player1) || (index == 15 && screenView.currentPlayer == .player2){
            screenView.holes[index] += 1
            shellsInHand -= 1
            totalSteps = 0 // CURRENT PLAYER GET ANOTHER TURN
            screenView.playerTurnLabel.text = "Sheelds in hands : \(shellsInHand)"
            determineTheWinner()
            updateNumberOfSheelds(index: index)
            screenView.unlockButton()
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
                    self.screenView.unlockButton()
                }
                determineTheWinner()
                timer?.invalidate()
            }
        }
    }
    
    func updateUI(index: Int) {
        if previousIndex != nil {
            screenView.buttons[previousIndex].alpha = 0.3
        }
        screenView.buttons[index].alpha = 1
    }
    
    func updateNumberOfSheelds(index: Int) {
        if gotTheWinner {
            for i in 0...15 {
                screenView.buttons[i].setTitle("\(screenView.holes[i])", for: .normal)
                screenView.buttons[i].alpha = 1
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    self.screenView.buttons[i].alpha = 0.3
                }
            }
            gotTheWinner = false
        }
        if shellsInHand == 1, screenView.holes[index] == 0, index != 7 && index != 15 {
            for i in 0...15 {
                screenView.buttons[i].setTitle("\(screenView.holes[i])", for: .normal)
            }
        }
        else {
            screenView.buttons[index].setTitle("\(screenView.holes[index])", for: .normal)
        }
    }
    
    func tembak(index: Int) {
        if totalSteps >= 15 { // UNTUK CEK SUDAH SATU PUTARAN/BLM
            let oppositeIndex = 14 - index
            if screenView.holes[oppositeIndex] != 0 {
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
