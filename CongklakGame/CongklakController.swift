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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.holeTapped = { [weak self] index in
            self?.startPlaying(pickedHole: index)
        }
    }
    
    func startPlaying(pickedHole: Int) {
        var index = pickedHole
        
        // UNTUK CEK HOLE YANG DIPILIH ADA ISINYA/TIDAK KOSONG
        if screenView.holes[index] == 0 {
            screenView.playerTurnLabel.text = "IT'S EMPTY. CHOOSE ANOTHER HOLE"
            screenView.unlockButton()
        }
        
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
                
                updateNumberOfSheelds(index: index)
                screenView.playerTurnLabel.text = "Sheelds in hands : \(shellsInHand)"
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
            updateNumberOfSheelds(index: index)
            screenView.playerTurnLabel.text = "Sheelds in hands : \(shellsInHand)"
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
