//
//  searchResultViewController.swift
//  KakaoProject
//
//  Created by Dannian Park on 2020/08/21.
//  Copyright © 2020 Dannian Park. All rights reserved.
//

import Foundation
import UIKit
public enum State {
    // loading state
    case loading
    // render state
    case render(UIViewController)
}
class ContentsViewController : UIViewController {
    // view의 이동을 위한 컨트롤러
    var vc: UIViewController? //
    private var state : State? //
    
    
    func trans(newState : State) {
        if let _vc = self.vc {
            _vc.remove()
        }
        self.state = newState
        let newVC = viewController(state: newState)
        self.vc = newVC
        self.add(child: newVC)
    }
    
    private func viewController(state: State) -> UIViewController {
        switch state {
        case .loading:
            return UIViewController()
        case .render(let _vc):
            return _vc
        }
    }
}

class searchResultViewController : ContentsViewController {
    private var suggestViewController: SearchSuggestViewController!
    var didSelect: (String) -> Void = { (result) in }
    
    var delegate : mainViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    deinit {
        dprint("Check deinit view")
    }
    
    private func _dealloc() {
        
    }
    
    private func commonInit() {
        let storyboard = UIStoryboard(name: String(describing:SearchSuggestViewController.self), bundle: nil)
        self.suggestViewController = storyboard.instantiateViewController(withIdentifier: String(describing: SearchSuggestViewController.self)) as? SearchSuggestViewController
        self.suggestViewController.didSelect = self.didSelect
    }
    
    //searchStr : 찾는 String, searchType : 어떻게 보여줄지 관련된 enum
    func searchAct(searchStr: String, searchType: searchTypeEnum) {
        switch searchType {
        case .partOf :
            self.suggestViewController.searchString = searchStr
            self.trans(newState: .render(self.suggestViewController))
        case .done :
            let listShowController = AppstoreResultTableViewController()
            listShowController.delegate = self.delegate
            //listShowController.delegate = self
            //listShowController.search(searchStr: searchStr)
            dprint("Check search Str : \(searchStr)")
            DBManager.sharedInstance.addCurrentSearchText(string: searchStr)
            listShowController.appSearch(string: searchStr)
            self.trans(newState: .render(listShowController))
        }
    }
}
