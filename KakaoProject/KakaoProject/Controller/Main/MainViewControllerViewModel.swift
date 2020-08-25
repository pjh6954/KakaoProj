//
//  MainViewControllerViewModel.swift
//  KakaoProject
//
//  Created by Dannian Park on 2020/08/25.
//  Copyright © 2020 Dannian Park. All rights reserved.
//

import Foundation
protocol MainViewControllerViewModelInput {
    
}

protocol MainViewControllerViewModelOutput {
    
}

protocol MainViewControllerViewModelType {
    var inputs: MainViewControllerViewModelInput {get}
    var outputs: MainViewControllerViewModelOutput {get}
}

class MainViewControllerViewModel : MainViewControllerViewModelType, MainViewControllerViewModelInput, MainViewControllerViewModelOutput{
    init() {
        dprint("init MainViewControllerViewModel")
    }
    
    deinit {
        dprint("deinit MainViewControllerViewModel")
    }
    
    
    
    //output
    
    var inputs: MainViewControllerViewModelInput { return self }
    var outputs: MainViewControllerViewModelOutput { return self }
}
