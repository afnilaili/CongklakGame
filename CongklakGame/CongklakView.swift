//
//  CongklakView.swift
//  CongklakGame
//
//  Created by Afni Laili on 12/02/21.
//

import UIKit

class CongklakView: View {
    
    let deviceWidth = UIScreen.main.bounds.width
    let deviceHeight = UIScreen.main.bounds.height
    var holeTapped: ((Int) -> Void)?
    
    override func setViews() {
        self.backgroundColor = .white
        generateHoles()
    }

    func generateHoles() {
        for i in 0..<16 {
            addButton(tag: i)
        }
    }
    
    func addButton(tag: Int) {
        let holeButton: UIButton = {
            let button = UIButton()
            button.setTitle("39", for: .normal)
            button.layer.cornerRadius = 8
            button.backgroundColor = .systemBlue
            button.addTarget(self, action: #selector(chooseHole), for: .touchUpInside)
            button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            button.alpha = 0.7
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
        
        holeButton.setTitle("\(tag)", for: .normal)
        holeButton.tag = tag
        addSubview(holeButton)
    }
    
    @objc func chooseHole(sender: UIButton) {
        holeTapped?(sender.tag)
    }
    
}
