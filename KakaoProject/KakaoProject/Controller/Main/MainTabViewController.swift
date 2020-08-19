//
//  MainTabViewController.swift
//  KakaoProject
//
//  Created by Dannian Park on 2020/08/19.
//  Copyright © 2020 Dannian Park. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.commonInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let items = self.tabBar.items {
            self.selectedIndex = items.endIndex - 1
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
    }
    
    private func commonInit() {
        if let navigation = self.navigationController {
            
        }
    }
    
    private func dataInit(){
        
    }

    deinit {
        dprint("Check Deinit MainTabViewController")
    }

    
}
