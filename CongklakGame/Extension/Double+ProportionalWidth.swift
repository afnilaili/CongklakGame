//
//  Double+ProportionalWidth.swift
//  CongklakGame
//
//  Created by Afni Laili on 14/02/21.
//

import UIKit

extension Double {
	func proportionalToWidth() -> CGFloat {
		return (CGFloat(self) / 414) * UIScreen.main.bounds.width
	}
	
	func proportionalToHeight() -> CGFloat {
		return (CGFloat(self) / 896) * UIScreen.main.bounds.height
	}
}
