//
//  HomeViewController.swift
//  Demo
//
//  Created by Pritam on 3/9/21.
//

import UIKit
import Reusable

class HomeViewController: UIViewController, ViewType, StoryboardSceneBased {
    var viewModel: HomeViewModel!
    
    static var sceneStoryboard = UIStoryboard(name: StoryboardScene.Initialization.storyboardName, bundle: nil)
    
    override func viewDidLoad() {
        
    }
}
