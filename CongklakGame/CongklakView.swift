//
//  CongklakView.swift
//  CongklakGame
//
//  Created by Afni Laili on 12/02/21.
//

import UIKit

enum Player: String {
    case player1
    case player2
}

class CongklakView: View {
	
	enum ViewEvent {
		case holeTapped(index: Int)
		case decideTapped
		case restartTapped
	}
	
	var onViewEvent: ((ViewEvent) -> Void)?
    
    let deviceWidth = UIScreen.main.bounds.width
    let deviceHeight = UIScreen.main.bounds.height
	
    var holes: [Int] = [] //Fill holes
    //var holes = [0,0,0,0,0,0,1,41,7,7,7,7,7,7,6,8] // ngacang 0,1
//    var holes = [7,7,7,7,7,7,6,8,0,0,0,0,0,0,1,41] // ngacang 8,9
    var currentPlayer: Player!
    var buttons: [UIButton] = []
    var labels: [UILabel] = []
    
    lazy var playerTurnLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Decide Who Will Go First"
        label.frame = CGRect(x: 0, y: 20, width: deviceWidth, height: 50)
        label.center = CGPoint(x: deviceWidth/2, y: deviceHeight/2)
        return label
    }()
    
    lazy var decideTurnButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemYellow
        button.setTitle("Decide", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(decideTurn), for: .touchUpInside)
		button.frame = CGRect(x: 0, y: 0, width: (100.0).proportionalToHeight(), height: (40.0).proportionalToHeight())
        return button
    }()
    
    lazy var restartButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemYellow
        button.alpha = 0.3
        button.setTitle("Restart", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(restart), for: .touchUpInside)
		button.frame = CGRect(x: 0, y: 0, width: (100.0).proportionalToHeight(), height: (40.0).proportionalToHeight())
        return button
    }()
    
    //MARK: - Life Cycle
    
    override func setViews() {
        addSubview(playerTurnLabel)
        addSubview(decideTurnButton)
        addSubview(restartButton)
        backgroundColor = .black
		decideTurnButton.center = CGPoint(x: deviceWidth-((125.0).proportionalToWidth()), y: deviceHeight-(55.0).proportionalToHeight())
        
		restartButton.center = CGPoint(x: (125.0).proportionalToWidth(), y: deviceHeight-(55.0).proportionalToHeight())
    }
    
    override func onViewDidLoad() {
        fillHoles()
        generateHoles()
    }
    
    //MARK: - Fill Hole
    
    func fillHoles() {
        holes = Array(repeating: 7, count: 16)
        holes[7] = 0
        holes[15] = 0
    }
    
    //MARK: - Create Button
    
    func generateHoles() {
        for i in 0..<holes.count {
            addButton(tag: i)
        }
    }
    
    func addButton(tag: Int) {
        let holeButton: UIButton = {
            let button = UIButton()
            button.setTitle("39", for: .normal)
            button.layer.cornerRadius = 8
            button.backgroundColor = .systemBlue
            button.isEnabled = false
            button.addTarget(self, action: #selector(pickHole), for: .touchUpInside)
			button.frame = CGRect(x: 0, y: 0, width: (50.0).proportionalToHeight(), height: (50.0).proportionalToHeight())
            button.alpha = 0.3
            return button
        }()
        
        let player1Y = deviceHeight/2 + 90
		let player1X = deviceWidth/2 - (300.0).proportionalToWidth()
        
        let player2Y = deviceHeight/2 - 90
		let player2X = deviceWidth/2 - (300.0).proportionalToWidth()
        
		let space = (75.0).proportionalToWidth()
        
        if tag == 7 {
			holeButton.frame = CGRect(x: 0, y: 0, width: (50.0).proportionalToHeight(), height: (100.0).proportionalToHeight())
            holeButton.center = CGPoint(x: player1X, y: deviceHeight/2)
        }
        else if tag == 15 {
			holeButton.frame = CGRect(x: 0, y: 0, width: (50.0).proportionalToHeight(), height: (100.0).proportionalToHeight())
            holeButton.backgroundColor = .systemRed
			holeButton.center = CGPoint(x: player2X + (600.0).proportionalToWidth(), y: deviceHeight/2)
        }
        if tag < 7 {
            holeButton.center = CGPoint(x: (CGFloat(7-tag)*space + player1X), y: player1Y)
        }
        else if tag > 7, tag < 15 {
            holeButton.backgroundColor = .systemRed
            holeButton.center = CGPoint(x: player2X + CGFloat(tag-7)*space, y: player2Y)
        }

        holeButton.setTitle("\(holes[tag])", for: .normal)
        holeButton.tag = tag
        buttons.append(holeButton)
        
        addSubview(holeButton)
    }
    
    //MARK: - Buttons Setting
    
    func lockButton() {
        for button in buttons {
            button.isEnabled = false
            button.alpha = 0.3
        }
    }
    
    //MARK: - @objc target
    
    @objc func decideTurn() {
        restartButton.alpha = 1
        restartButton.isEnabled = true
		onViewEvent?(.decideTapped)
    }
    
    @objc func pickHole(sender: UIButton) {
        lockButton()
		onViewEvent?(.holeTapped(index: sender.tag))
    }
    
    @objc func restart() {
		onViewEvent?(.restartTapped)
    }
    
}
