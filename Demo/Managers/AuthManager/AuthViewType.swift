//
//  AuthViewType.swift
//  Demo
//
//  Created by Pritam on 15/9/21.
//

import UIKit

protocol AuthViewType where Self: UIViewController {
    func loginCompletion(isSuccess: Bool, error: Error?)
    func logoutCompletion(isSuccess: Bool)
}
