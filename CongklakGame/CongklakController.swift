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
    var isNgacang = false
    var ngacangs: [Int] = []
    var ngacangPlayer: Player!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        unlockButton()
        screenView.holeTapped = { [weak self] index in
            self?.startPlaying(pickedHole: index)
        }
    }
    
    // UNTUK CEK HOLE YANG DIPILIH APAKAH ADA ISINYA(TIDAK KOSONG)
    func isEmptyHole(index: Int) {
        if screenView.holes[index] == 0 {
            screenView.playerTurnLabel.text = "IT'S EMPTY. CHOOSE ANOTHER HOLE"
            unlockButton()
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
                
                screenView.playerTurnLabel.text = "Shells in hands : \(shellsInHand-1)"
                
                // SKIP NGACANG HOLES
                index = skipNgacang(index: index)
                
                // CHECK IF THE HOLE IS THE LAST ELEMENT OF ARRAY (menghindari index out of range)
                if index > screenView.holes.count-1 {
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
                    screenView.holes[index] += 1
                    shellsInHand -= 1
                }
                
                updateNumberOfShells(index: index)
                print(screenView.holes)
                previousIndex = index
                index += 1
                
            } else {
                timer.invalidate()
            }
        })
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
                screenView.buttons[i].setTitle("\(screenView.holes[i])", for: .normal)
                screenView.buttons[i].alpha = 1
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    self.screenView.buttons[i].alpha = 0.3
                    self.unlockButton()
                    self.screenView.playerTurnLabel.text = "\(self.screenView.currentPlayer.rawValue)'s turn"
                }
            }
            gotTheWinner = false
        }
        if shellsInHand == 0, screenView.holes[index] == 0, index != 7 && index != 15 {
            for i in 0...15 {
                screenView.buttons[i].setTitle("\(screenView.holes[i])", for: .normal)
            }
        }
        else {
            screenView.buttons[index].setTitle("\(screenView.holes[index])", for: .normal)
        }
    }
    
    func unlockButton() {
        if screenView.currentPlayer == .player1 {
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
    
}
