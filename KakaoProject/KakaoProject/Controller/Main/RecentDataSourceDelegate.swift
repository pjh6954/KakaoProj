//
//  RecentDataSourceDelegate.swift
//  KakaoProject
//
//  Created by Dannian Park on 2020/08/19.
//  Copyright © 2020 Dannian Park. All rights reserved.
//

import Foundation
import UIKit
class RecentDataSourceDelegate: NSObject {
    //Constants.recentArray에는 갯수 제한을 두되, 일단 10개로 설정해두자.
    private var recent : [String] = [] //UserDefaults.standard.stringArray(forKey: Constants.recentArray) ?? []
    //table select시 callback을 위한 함수 정의
    var isSelect : ((String) -> Void)? = { (_) in }//optional
    
    func reLoadData() {
        DBManager.sharedInstance.getCurrentSearchTextFromDB { (result) in
            self.recent = result.compactMap({ (element) -> String in
                return element.text
                }).reversed()
            self.recent = Array(self.recent.prefix(10))
        }
    }
}
//여기에 tableviewdelegate와 datasource 선언 이유는 사용될 데이터가 recent이기 때문에 controller에 굳이 선언할 필요가 없다고 생각되기 때문.
extension RecentDataSourceDelegate : UITableViewDelegate, UITableViewDataSource {
    
    //select Action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < self.recent.count, !self.recent[indexPath.row].isEmpty else {return}
        self.isSelect?(self.recent[indexPath.row])
    }
    
    //Section count
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //최근 검색데이터 갯수만큼 뿌려준다
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentSearchCell")
        cell?.textLabel?.text = self.recent[indexPath.row]
        cell?.textLabel?.textColor = UIColor.blue
        return cell!
    }
    
    
}
