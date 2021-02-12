//
//  View.swift
//  CongklakGame
//
//  Created by Afni Laili on 12/02/21.
//

import UIKit

class View: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViews() {}
    func onViewDidLoad() {}
    func onViewWillAppear() {}
    func onViewDidAppear() {}
    func onViewWillDisAppear() {}
    func onViewDidDisAppear() {}
    func onViewWillLayoutSubViews() {}
    func onViewDidLayoutSubViews() {}
}
