//
//  UIButtonExtention.swift
//  AssignmentTag
//
//  Created by Prasanta Santikari on 05/02/22.
//

import Foundation
import UIKit

extension UIButton {
    func configure(_ cornerRadius: CGFloat, borderColor: UIColor) {
        self.layer.borderWidth = 3.0
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
    }
}
