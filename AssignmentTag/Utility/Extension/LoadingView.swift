//
//  LoadingView.swift
//  AssignmentTag
//
//  Created by Prasanta Santikari on 05/02/22.
//

import Foundation
import UIKit

public class LoadingView {
    
    internal static var spinner: UIActivityIndicatorView?
    
    public static func show() {
        DispatchQueue.main.async {
            NotificationCenter.default.addObserver(self, selector: #selector(update), name: UIDevice.orientationDidChangeNotification, object: nil)
            if spinner == nil, let window = UIWindow.key {
                let frame = UIScreen.main.bounds
                let spinner = UIActivityIndicatorView(frame: frame)
                spinner.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                spinner.style = UIActivityIndicatorView.Style.large
                window.addSubview(spinner)
                
                spinner.startAnimating()
                self.spinner = spinner
            }
        }
    }
    
    public static func hide() {
        DispatchQueue.main.async {
            guard let spinner = spinner else { return }
            spinner.stopAnimating()
            spinner.removeFromSuperview()
            self.spinner = nil
        }
    }
    
    @objc public static func update() {
        DispatchQueue.main.async {
            if spinner != nil {
                hide()
                show()
            }
        }
    }
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
