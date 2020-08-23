//
//  RealmModels.swift
//  KakaoProject
//
//  Created by Dannian Park on 2020/08/22.
//  Copyright © 2020 Dannian Park. All rights reserved.
//

import Foundation
import RealmSwift
class currentSearchData : Object {
    @objc dynamic var text : String = ""
    convenience init(text : String) {
        self.init()
        self.text = text
    }
}
