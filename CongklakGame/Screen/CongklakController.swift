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
				self?.pickPlayer()
				self?.screenView.decideTurnButton.alpha = 0.3
			case .restartTapped:
				self?.restart()
			}
		}
	}

}
