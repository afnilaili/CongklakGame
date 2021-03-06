//
//  CongklakGame.swift
//  CongklakGame
//
//  Created by Afni Laili on 14/02/21.
//

import UIKit

extension CongklakController {
    //MARK: - Fill Holes
    
    func fillHoles() {
        holes = Array(repeating: 7, count: 16)
        holes[7] = 0
        holes[15] = 0
    }
    
    //MARK: - Choose Player
    
    func pickPlayer() {
        let player1 = Player.Player_Blue
        let player2 = Player.Player_Red
        let players: [Player] = [player1, player1, player2, player1, player2, player2, player1, player2]
        let getPlayer = players.randomElement()!
        
        self.screenView.playerTurnLabel.text = "\(getPlayer) turn"
        screenView.currentPlayer = getPlayer
        unlockButton()
    }
    
    //MARK: - Start Playing Logic
    
    func startPlaying(pickedHole: Int) {
        var index = pickedHole
        
        isEmptyHole(index: index)
        shellsInHand = holes[index]
        holes[index] = 0
        screenView.buttons[index].setTitle("\(holes[index])", for: .normal)
        index += 1
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true, block: { [self] timer in
            if shellsInHand > 0 {
                totalSteps += 1
                
                screenView.playerTurnLabel.text = "Shells in hands : \(shellsInHand-1)"
                
                // SKIP NGACANG HOLES
                index = skipNgacang(index: index)
                
                // CHECK IF THE HOLE IS THE LAST ELEMENT OF ARRAY (menghindari index out of range)
                if index > holes.count-1 {
                    index = 0
                }
                // SKIP STORE HOUSE LAWAN
                index = isSkipOpponentStoreHouse(index: index)

                // ONLY THE HOLE THAT IS GETTING A TURN IS ON
                holeUIUpdate(index: index)
                
                // CEK IF SHELLS IN HAND SISA 1
                if shellsInHand == 1 {
                    isLastSheeld(index: index)
                }
                // SHELLS MASIH ADA > 1
                else {
                    holes[index] += 1
                    shellsInHand -= 1
                }
                
                updateNumberOfShells(index: index)
                print(holes)
                previousIndex = index
                index += 1
                
            } else {
                timer.invalidate()
            }
        })
    }
    
    //MARK: - Start Playing Needed
    
    // UNTUK CEK HOLE YANG DIPILIH APAKAH ADA ISINYA(TIDAK KOSONG)
    func isEmptyHole(index: Int) {
        if holes[index] == 0 {
            screenView.playerTurnLabel.text = "IT'S EMPTY. CHOOSE ANOTHER HOLE"
            unlockButton()
        }
    }
    
    func holeUIUpdate(index: Int) {
        if previousIndex != nil {
            screenView.buttons[previousIndex].alpha = 0.3
        }
        screenView.buttons[index].alpha = 1
    }
    
    func updateNumberOfShells(index: Int) {
        if gotTheWinner {
            for i in 0...15 {
                screenView.buttons[i].setTitle("\(holes[i])", for: .normal)
                if !isGameOver {
                    screenView.buttons[i].alpha = 1
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        self.screenView.buttons[i].alpha = 0.3
                        self.unlockButton()
                        self.screenView.playerTurnLabel.text = "\(self.screenView.currentPlayer.rawValue) turn"
                    }
                }
                else {
                    screenView.buttons[i].alpha = 1
                    screenView.decideTurnButton.isEnabled = true
                }
            }
            gotTheWinner = false
        }
        
        if shellsInHand == 0, holes[index] == 0, index != 7 && index != 15 {
            for i in 0...15 {
                screenView.buttons[i].setTitle("\(holes[i])", for: .normal)
            }
        }
        else {
            screenView.buttons[index].setTitle("\(holes[index])", for: .normal)
        }
    }
    
    func unlockButton() {
        if screenView.currentPlayer == .Player_Blue {
            for i in 0...7 {
                if i<7 {
                    screenView.buttons[i].isEnabled = true
                }
                screenView.buttons[i].alpha = 1
            }
        }
        else {
            for i in 8...15 {
                if i<15 {
                    screenView.buttons[i].isEnabled = true
                }
                screenView.buttons[i].alpha = 1
            }
        }
        // PLAYER CAN'T TAKE THE SHEELLS FROM NGACANG HOLES
        if isNgacang {
            for i in ngacangs {
                screenView.buttons[i].isEnabled = false
            }
        }
    }
    
    //MARK: - Restart The Game
    
    func restart() {
        //MARK: Stop Game
        shellsInHand = 0
        
        //MARK: Non-Aktifkan Restart Button
        screenView.restartButton.alpha = 0.3
        screenView.restartButton.isEnabled = false
        
        //MARK: Aktifkan Decide Button
        screenView.decideTurnButton.alpha = 1
        screenView.decideTurnButton.isEnabled = true
        screenView.decideTurnButton.setTitle("Toss-Up", for: .normal)
        
        //MARK: Update Shells And Holes
        fillHoles()
        for i in 0...15 {
            screenView.buttons[i].isEnabled = false
            screenView.buttons[i].setTitleColor(.white, for: .normal)
            screenView.buttons[i].alpha = 0.3
            screenView.buttons[i].setTitle("\(holes[i])", for: .normal)
            if i <= 7 {
                screenView.buttons[i].backgroundColor = .systemBlue
            }
            else {
                screenView.buttons[i].backgroundColor = .systemRed
            }
        }
        
        //MARK: Update Text Label
        screenView.playerTurnLabel.text = "Decide Who Will Go First"
        
        //MARK: Restart Properties
        totalSteps = 0
        gotTheWinner = false
        isNgacang = false
        isGameOver = false
        ngacangs = []
        
    }
    
}
