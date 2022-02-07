//
//  UITextFieldExtension.swift
//  AssignmentTag
//
//  Created by Prasanta Santikari on 07/02/22.
//

import Foundation
import UIKit

extension UITextField {
    func setRightImage(imageName:String) {
        let imageView = UIImageView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 10,
                                                  height: 10))
        imageView.image = UIImage(named: imageName)
        self.rightView = imageView
        self.rightViewMode = .always
    }
}
