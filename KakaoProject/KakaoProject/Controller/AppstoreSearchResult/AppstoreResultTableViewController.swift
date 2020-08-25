//
//  AppstoreResultTableViewController.swift
//  KakaoProject
//
//  Created by Dannian Park on 2020/08/22.
//  Copyright © 2020 Dannian Park. All rights reserved.
//

import Foundation
import UIKit

class AppstoreResultTableViewController: UITableViewController {
    var appsData : [AppSearchResponse.AppSearchData] = []
        
    var delegate : mainViewDelegate?
    
    private var viewModel : AppstoreResultTableViewModel? = nil
    
    private let cellNibName = "AppstoreResultTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
        self.viewModelBinding()
    }
    
    private func commonInit() {
        let cellNib = UINib(nibName: self.cellNibName, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: self.cellNibName)
        self.tableView.separatorStyle = .none
    }
    
    private func viewModelBinding() {
        if self.viewModel == nil {
            self.viewModel = AppstoreResultTableViewModel()
        }
        guard let _vm = self.viewModel else {return}
        _vm.resultHandler = { [weak self] result in
            guard let strongSelf = self else {return}
            dprint("result handler : \(result) \n \(result.results) && \(result.results.first)")
            strongSelf.appsData = result.results
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellNibName, for: indexPath) as? AppstoreResultTableViewCell else {return AppstoreResultTableViewCell()}
        cell.setData(appData: self.appsData[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dprint("Check Onclick Event : \(indexPath.row)")
        self.delegate?.showAppDetail(appData: self.appsData[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel?.dataTaskCancelRequest()
        guard let _ = cell as? AppstoreResultTableViewCell else {return}
        dprint("did end displaying??")
    }
    func appSearch(string: String) {
        //View did load 이전에 먼저 불려진다. viewcontroller에 모든 FUNction 넣을때와는 다름.
        self.viewModelBinding()
        self.viewModel?.appSearch(string: string)
    }
}
