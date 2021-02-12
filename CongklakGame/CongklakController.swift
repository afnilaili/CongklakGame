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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.holeTapped = { [weak self] index in
            self?.startPlaying(pickedHole: index)
        }
    }
    
    func isMoveAround(index: Int) {
        if previousIndex != nil {
            screenView.buttons[previousIndex].alpha = 0.3
        }
        screenView.buttons[index].alpha = 1
        
    }
    
    func startPlaying(pickedHole: Int) {
        var index = pickedHole
        
        shellsInHand = screenView.holes[index]
        screenView.holes[index] = 0
        index += 1
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true, block: { [self] timer in
            
            if shellsInHand > 0 {
                var shouldContinue = false

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
                isMoveAround(index: index)
                
                // CEK IF SHELLS IN HAND SISA 1
                if shellsInHand == 1 {
                    //CEK APAKAH DI STOREHOUSE MILIK SENDIRI
                    if (index == 7 && screenView.currentPlayer == .player1) || (index == 15 && screenView.currentPlayer == .player2){
                        //isMoveAround(index: index)
                        screenView.holes[index] += 1
                        shellsInHand -= 1
                        //currentPlayer play lg
                        print(screenView.holes)
                        timer.invalidate()
                    }
                    
//                    else if (index == 7 && screenView.currentPlayer != .player1) || (index == 15 && screenView.currentPlayer != .player2){
//                        previousIndex = index
//                        index += 1
//                        shouldContinue = true
//                    }
                    // KETIKA BUKAN DI STOREHOUSE
                    if index != 7 && index != 15 {
                        // CEK APAKAH ADA SHEELDS DI CURRENTHOLE
                        if screenView.holes[index] != 0 {
                            //isMoveAround(index: index)
                            shellsInHand = screenView.holes[index]+1
                            screenView.holes[index] = 0
                        }
                        else {
                            screenView.holes[index] += 1
                            print(screenView.holes)
                            timer.invalidate()
                        }
                    }
                }
                // SHEELDS MASIH ADA > 1
                else {
                    //SKIP STOREHOUSE LAWAN
//                    if (index == 7 && screenView.currentPlayer != .player1) || (index == 15 && screenView.currentPlayer != .player2){
//                        previousIndex = index
//                        index += 1
//                        shouldContinue = true
//                    }
                    //else {
                        //isMoveAround(index: index)
                        screenView.holes[index] += 1
                        shellsInHand -= 1
                    //}
                }
                if !shouldContinue {
                    previousIndex = index
                    index += 1
                }
                print(screenView.holes)
            } else {
                timer.invalidate()
            }
        })
    }
    
}
