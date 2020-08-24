//
//  MainViewController.swift
//  KakaoProject
//
//  Created by Dannian Park on 2020/08/19.
//  Copyright © 2020 Dannian Park. All rights reserved.
//

import Foundation
import UIKit

protocol mainViewDelegate {
    func showAppDetail(appData: AppSearchResponse.AppSearchData)
    func reloadWhenSearching()
}

class MainViewController : UITableViewController {
    
    let recentDelegate = RecentDataSourceDelegate()
    
    var searchController : UISearchController!
    
    private var resultViewController = searchResultViewController()
    
    private var searchState: searchTypeEnum = .done
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
        self.dataInit()
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
    
    private func commonInit() {
        //search controller setting
        self.searchController = UISearchController(searchResultsController: self.resultViewController)
        self.resultViewController.delegate = self
        self.resultViewController.didSelect = self.searchwithStr
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.placeholder = "찾기"
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true // ?
        
        
        
        self.tableView.delegate = self.recentDelegate
        self.tableView.dataSource = self.recentDelegate
        self.recentDelegate.isSelect = self.searchwithStr
        
        self.extendedLayoutIncludesOpaqueBars = true // ?
        self.navigationController?.navigationBar.setShadow(true)
        
        
    }
    
    private func dataInit(){
        self.recentDelegate.reLoadData() // 이 데이터는 10개 리미트.
        self.tableView.reloadThisView()
    }
    
    
    private func searchwithStr(_ searchStr: String) {
        self.searchController.searchBar.text = searchStr
        self.searchState = .done
        self.searchController.isActive = true
        self.searchController.searchBar.resignFirstResponder()
        self.navigationController?.navigationBar.setShadow(false)
    }
    
}

extension MainViewController : mainViewDelegate {
    func showAppDetail(appData: AppSearchResponse.AppSearchData) {
        let storyboard = UIStoryboard(name: "AppStoreDetailViewController", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "AppStoreDetailViewController") as? AppStoreDetailViewController else {return}
        //navi.pushViewController(vc, animated: true)
        vc.modalPresentationStyle = .fullScreen
        vc.appData = appData
        //self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.pushViewController(viewController: vc, animated: true, completion: {
        })
    }
    func reloadWhenSearching() {
        DispatchQueue.main.async {
            self.dataInit()
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchState = searchText.isEmpty ? .done : .partOf
        self.navigationController?.navigationBar
            .setShadow(searchText.isEmpty)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.navigationBar.setShadow(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        self.searchwithStr(text)
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
            !text.isEmpty else {
                return
        }
        self.resultViewController.searchAct(searchStr: text, searchType: self.searchState)
    }
}
