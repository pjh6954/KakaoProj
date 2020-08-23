//
//  SearchSuggestViewController.swift
//  KakaoProject
//
//  Created by Dannian Park on 2020/08/21.
//  Copyright © 2020 Dannian Park. All rights reserved.
//

import Foundation
import UIKit

//검색 데이터들 기준으로 보여주자.
class SearchSuggestViewController: UITableViewController {
    
    private var currentNames = [String]()
    
    var didSelect: (String) -> Void = { (result) in }
    var searchString: String = String() {
        didSet{
            self.namePrefixColor(prefix: self.searchString) { (_) in
                self.tableView.reloadThisView()
            }
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "suggestCell", for: indexPath) as? SearchSuggestTableViewCell else {
            return SearchSuggestTableViewCell()
        }
        cell.setting(searchString: self.searchString, suggest: self.currentNames[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelect(currentNames[indexPath.row])
    }
}

extension SearchSuggestViewController {
    func namePrefixColor(prefix: String, completion: @escaping(_ result : [String]) -> Void) {
        /*
        // all list showing
        DBManager.sharedInstance.getCurrentSearchTextFromDB { (result) in
            self.currentNames.removeAll()
            dprint("DB Search Suggest View Controller : \(result)")
            self.currentNames = result.compactMap({ (element) -> String in
                return element.text
                }).reversed() // 최근 추가 순으로 보여주기 위해서 reverse사용
            completion(self.currentNames.filter({ (element) -> Bool in
                element.caseInsensitivePrefix(prefix)
            }))
        }
        */
        DBManager.sharedInstance.getCurrentSearchTextWithSTRFromDB(searchString: prefix) { (result) in
            self.currentNames.removeAll()
            dprint("DB Search Suggest View Controller : \(result)")
            self.currentNames = result.compactMap({ (element) -> String in
                return element.text
                }).reversed() // 최근 추가 순으로 보여주기 위해서 reverse사용
            completion(
                self.currentNames.filter({ (element) -> Bool in
                    element.caseInsensitivePrefix(prefix)
                })
            )
        }
    }
}
