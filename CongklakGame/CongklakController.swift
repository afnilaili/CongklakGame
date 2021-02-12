//
//  CongklakController.swift
//  CongklakGame
//
//  Created by Afni Laili on 12/02/21.
//

import UIKit

class CongklakController: ViewController<CongklakView> {
    
    enum Player {
        case player1
        case player2
    }
    
    var holes = Array(repeating: 7, count: 16) //Fill holes
    var currentPlayer = Player.player1
    var shellsInHand = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillHoles()
        screenView.holeTapped = { [weak self] index in
            self?.startPlaying(pickedHole: index)
        }
    }
    
    func fillHoles() {
        holes[7] = 0
        holes[15] = 0
    }
    
    func isLastSheeld(index: Int) {
        if index != 7 && index != 15 {
            // CEK APAKAH ADA SHEELDS DI CURRENTHOLE
            if holes[index] != 0 {
                shellsInHand = holes[index]+1
                holes[index] = 0
            }
            else {
                holes[index] += 1
            }
        }
        
        //CEK APAKAH DI STOREHOUSE MILIK SENDIRI
        else if (index == 7 && currentPlayer == Player.player1) || (index == 15 && currentPlayer == Player.player2){
            holes[index] += 1
            shellsInHand -= 1
        }
        
    }
    
    func startPlaying(pickedHole: Int) {
        var index = pickedHole
        
        shellsInHand = holes[index]
        holes[index] = 0
        index += 1
        
        while shellsInHand > 0 {
            // MARK: Cek apakah posisi holes di element of array yg terakhir
            if index > holes.count-1 {
                index = 0
            }
            
            // CEK IF SHELLS IN HAND SISA 1
            if shellsInHand == 1 {
                //CEK APAKAH DI STOREHOUSE MILIK SENDIRI
                if (index == 7 && currentPlayer == Player.player1) || (index == 15 && currentPlayer == Player.player2){
                    holes[index] += 1
                    shellsInHand -= 1
                    //currentPlayer play lg
                    print(holes)
                    break
                }
                
                if (index == 7 && currentPlayer != Player.player1) || (index == 15 && currentPlayer != Player.player2){
                    index += 1
                    continue
                }
                
                if index != 7 && index != 15 {
                    // CEK APAKAH ADA SHEELDS DI CURRENTHOLE
                    if holes[index] != 0 {
                        shellsInHand = holes[index]+1
                        holes[index] = 0
                    }
                    else {
                        holes[index] += 1
                        print(holes)
                        break
                    }
                }
            }
            // SHEELDS MASIH ADA > 1
            else {
                //SKIP STOREHOUSE LAWAN
                if (index == 7 && currentPlayer != Player.player1) || (index == 15 && currentPlayer != Player.player2){
                    index += 1
                    continue
                }
                holes[index] += 1
                shellsInHand -= 1
            }
            index += 1
            //print(holes)
        }
    }
    
}
