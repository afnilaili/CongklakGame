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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenView.holeTapped = { [weak self] index in
            self?.startPlaying(pickedHole: index)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false, block: { [self] timer in
            
            
        })
    }
    
    func isMoveAround(index: Int) {
        screenView.buttons[index].alpha = 1
    }
    
    func startPlaying(pickedHole: Int) {
        var index = pickedHole
        
        shellsInHand = screenView.holes[index]
        screenView.holes[index] = 0
        index += 1
        
        while shellsInHand > 0 {
            // CHECK IF THE HOLE IS THE LAST ELEMENT OF ARRAY
            if index > screenView.holes.count-1 {
                index = 0
            }
            
            // CEK IF SHELLS IN HAND SISA 1
            if shellsInHand == 1 {
                //CEK APAKAH DI STOREHOUSE MILIK SENDIRI
                if (index == 7 && screenView.currentPlayer == .player1) || (index == 15 && screenView.currentPlayer == .player2){
                    screenView.holes[index] += 1
                    shellsInHand -= 1
                    //currentPlayer play lg
                    print(screenView.holes)
                    break
                }
                
                else if (index == 7 && screenView.currentPlayer != .player1) || (index == 15 && screenView.currentPlayer != .player2){
                    index += 1
                    continue
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
                        print(screenView.holes)
                        break
                    }
                }
            }
            // SHEELDS MASIH ADA > 1
            else {
                //SKIP STOREHOUSE LAWAN
                if (index == 7 && screenView.currentPlayer != .player1) || (index == 15 && screenView.currentPlayer != .player2){
                    index += 1
                    continue
                }
                else {
                    screenView.holes[index] += 1
                    shellsInHand -= 1
                }
            }
            index += 1
            //print(holes)
        }
    }
    
}
