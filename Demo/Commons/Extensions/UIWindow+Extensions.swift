//
//  UIWindow+Extensions.swift
//  Demo
//
//  Created by Pritam on 3/9/21.
//

import UIKit

extension UIWindow {
    func swapRootViewContoller(
        with newController: UIViewController,
        animated: Bool,
        completion: (() -> Void)? = nil) {
        if !animated {
            rootViewController = newController
            completion?()
        } else {
            UIView.transition(
                with: self,
                duration: 0.25,
                options: .transitionCrossDissolve,
                animations: { [weak self] in
                let oldState = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                self?.rootViewController = newController
                UIView.setAnimationsEnabled(oldState)
                }, completion: { completed in
                    if completed {
                        completion?()
                    }
                }
            )
        }
    }
}
