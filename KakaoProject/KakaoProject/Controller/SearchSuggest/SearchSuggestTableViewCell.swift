//
//  SearchSuggestTableViewCell.swift
//  KakaoProject
//
//  Created by Dannian Park on 2020/08/21.
//  Copyright © 2020 Dannian Park. All rights reserved.
//

import Foundation
import UIKit

class SearchSuggestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var LBSuggestTitle: UILabel!
    
    func setting(searchString: String, suggest: String) {
        //searchString : 입력된 값, suggest 이전 검색 내역의 string
        //font의 경우 확실히 변하는거 다시확인용. 나중에 지우기
        let attr : [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(white: 0.4, alpha: 1.0),
            .font: UIFont.systemFont(ofSize: 18, weight: .light)
        ]
        
        let attrString = NSAttributedString(string: suggest, attributes: attr)
        
        let mutableAttrString = NSMutableAttributedString(attributedString: attrString)
        
        mutableAttrString.boldSetting(searchString.lowercased()) // 소문자, 대문자 문제가 있었음.
        self.LBSuggestTitle.attributedText = mutableAttrString
    }
}
