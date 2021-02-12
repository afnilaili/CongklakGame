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
    
    let deviceWidth = UIScreen.main.bounds.width
    let deviceHeight = UIScreen.main.bounds.height
    var holeTapped: ((Int) -> Void)?
    var holes = Array(repeating: 7, count: 16) //Fill holes
    var currentPlayer: Player!
    var buttons: [UIButton] = []
    var labels: [UILabel] = []
    
    lazy var playerTurnLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "\(currentPlayer.rawValue)'s turn"
        label.frame = CGRect(x: 0, y: 20, width: deviceWidth, height: 50)
        label.center = CGPoint(x: deviceWidth/2, y: deviceHeight/2)
        return label
    }()
    
    override func setViews() {
        currentPlayer = .player1
        fillHoles()
        generateHoles()
        addSubview(playerTurnLabel)
        backgroundColor = .black
    }
    
    override func onViewDidLoad() {
        unlockButton()
    }
    
    func fillHoles() {
        holes[7] = 0
        holes[15] = 0
    }

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
            button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            button.alpha = 0.3
            return button
        }()
        
        let player1Y = deviceHeight/2 + 90
        let player1X = deviceWidth/2 - 300
        
        let player2Y = deviceHeight/2 - 90
        let player2X = deviceWidth/2 - 300
        
        if tag == 7 {
            holeButton.frame = CGRect(x: 0, y: 0, width: 50, height: 100)
            holeButton.center = CGPoint(x: player1X, y: deviceHeight/2)
        }
        else if tag == 15 {
            holeButton.frame = CGRect(x: 0, y: 0, width: 50, height: 100)
            holeButton.backgroundColor = .systemRed
            holeButton.center = CGPoint(x: player2X + 600, y: deviceHeight/2)
        }
        if tag < 7 {
            holeButton.center = CGPoint(x: (CGFloat((7-tag)*75) + player1X), y: player1Y)
        }
        else if tag > 7, tag < 15 {
            holeButton.backgroundColor = .systemRed
            holeButton.center = CGPoint(x: player2X + CGFloat(75*(tag-7)), y: player2Y)
        }
        
        setButtonColor(tag: tag, button: holeButton)
        holeButton.setTitle("\(holes[tag])", for: .normal)
        holeButton.tag = tag
        buttons.append(holeButton)
        
        addSubview(holeButton)
    }
    
    func setButtonColor(tag: Int, button: UIButton) {
        if currentPlayer == .player1 {
            if tag <= 7 {
                button.alpha = 1
            }
        }
        else if currentPlayer == .player2 {
            if tag > 7 {
                button.alpha = 1
            }
        }
    }
    
    func lockButton() {
        for button in buttons {
            button.isEnabled = false
            button.alpha = 0.3
        }
    }
    
    func unlockButton() {
        if currentPlayer == .player1 {
            for i in 0...7 {
                if i<7 {
                    buttons[i].isEnabled = true
                }
                buttons[i].alpha = 1
            }
        }
        else {
            for i in 8...15 {
                if i<15 {
                    buttons[i].isEnabled = true
                }
                buttons[i].alpha = 1
            }
        }
    }
    
    @objc func pickHole(sender: UIButton) {
        lockButton()
        holeTapped?(sender.tag)
    }
    
}
