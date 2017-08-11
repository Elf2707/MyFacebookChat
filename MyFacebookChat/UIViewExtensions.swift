//
//  UIViewExtensions.swift
//  MyFacebookChat
//
//  Created by Elf on 07.08.17.
//  Copyright © 2017 Elf. All rights reserved.
//

import UIKit

extension UIView {
    func addConstraintsWithFromat(format: String, views: UIView...) {
        var viewsDictionary = Dictionary<String, UIView>()
        for (idx, view) in views.enumerated() {
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary["v\(idx)"] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
