//
//  BaseCell.swift
//  MyFacebookChat
//
//  Created by Elf on 07.08.17.
//  Copyright © 2017 Elf. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {}
}
