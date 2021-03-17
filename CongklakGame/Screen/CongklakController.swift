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
    var isGameOver = false
    var ngacangs: [Int] = []
    var ngacangPlayer: Player!
	
    //Holes di view = holes di controller. holes di controller != holes di view
	var holes: [Int] = [] {
		didSet {
			screenView.holes = holes
		}
	}
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
		fillHoles()
        super.viewDidLoad()
        configureViewEvent()
    }
	
	// MARK: - Configuration
	
	func configureViewEvent() {
		screenView.onViewEvent = { [weak self] (viewEvent: CongklakView.ViewEvent) in
			switch viewEvent {
			case .holeTapped(let index):
				self?.startPlaying(pickedHole: index)
			case .decideTapped:
                if !(self!.isGameOver) {
                    self?.pickPlayer()
                    self?.screenView.decideTurnButton.alpha = 0.3
                    self?.screenView.decideTurnButton.isEnabled = false
                }
                else {
                    self?.restart()
                    self?.screenView.restartButton.alpha = 1
                    self?.screenView.restartButton.isEnabled = true
                    self?.screenView.playerTurnLabel.text = "\(self!.screenView.currentPlayer.rawValue) turn"
                    self?.unlockButton()
                    self?.screenView.decideTurnButton.alpha = 0.3
                    self?.screenView.decideTurnButton.isEnabled = false
                }
				
			case .restartTapped:
				self?.restart()
			}
		}
	}

}
