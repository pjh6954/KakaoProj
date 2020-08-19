//
//  Extension.swift
//  KakaoProject
//
//  Created by Dannian Park on 2020/08/19.
//  Copyright © 2020 Dannian Park. All rights reserved.
//

import Foundation
import UIKit

public func dprint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    let output = items.map { "\($0)" }.joined(separator: separator)
    Swift.print(output, terminator: terminator)
    #endif
}

extension UIViewController {
    
}
