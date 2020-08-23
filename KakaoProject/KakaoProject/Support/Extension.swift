//
//  Extension.swift
//  KakaoProject
//
//  Created by Dannian Park on 2020/08/19.
//  Copyright © 2020 Dannian Park. All rights reserved.
//

import Foundation
import UIKit

extension Bundle {
    //from stackoverflow
    func loadJsonFile<T: Decodable>(name: String) -> T {
        let path = Bundle.main.path(forResource: name, ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            fatalError("Invalid JSON structure.")
        }
    }
}

extension String {
    func caseInsensitivePrefix(_ str : String) -> Bool {
        return self.prefix(str.count).caseInsensitiveCompare(str) == .orderedSame
    }
    func convertNumberToSting() -> String {
        guard let intData = Int(self) else {return self}
        if intData < 1000 {
            return self
        }
        let intString = "\(intData)"
        //let startIdx : String.Index = intString.index(intString.startIndex, offsetBy: )
        let endIdx : String.Index = intString.index(intString.endIndex, offsetBy: -3)
        
        let returnString = intString[..<endIdx]
        return String("\(returnString)천")
    }
}

extension UIView {
    func constraintCenter(view: UIView){
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        let guide = view.safeAreaLayoutGuide
        let top = self.topAnchor.constraint(equalTo: guide.topAnchor)
        let bottom = self.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        let leading = self.leadingAnchor.constraint(equalTo: guide.leadingAnchor)
        let trailing = self.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        
        NSLayoutConstraint.activate([top, bottom, leading, trailing])
    }
}

extension UITableView {
    func reloadThisView() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}

extension UINavigationBar {
    func setShadow(_ hidden: Bool) {
        setValue(hidden, forKey: "hidesShadow")
    }
}

extension UIViewController {
    //stack overflow 참고
    func add(child: UIViewController) {
        self.addChild(child)
        child.view.constraintCenter(view: self.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard let _ = self.parent else {return}
        self.willMove(toParent: nil)
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
}

extension NSMutableAttributedString {
    public func boldSetting(_ text : String) {
        let boldRange = self.mutableString.range(of: text)
        if boldRange.location != NSNotFound {
            let boldAttr : [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18, weight: .light),
                .foregroundColor: UIColor.black
            ]
            self.addAttributes(boldAttr, range: boldRange)
        }
    }
}

extension UIImageView{
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension Date {
    func stringToStringWithToday(targetDateStr: String, format: String) -> String?{
        //yyyy-MM-dd'T'HH:mm:ss'Z'
        //string -> Date
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = format//"yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

        guard let date:Date = dateFormatter.date(from: targetDateStr) else {return nil}
        
        //Date -> String
        
        do {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.day]//[.year, .month, .day]
            formatter.unitsStyle = .full   // 이유는 모르겠으나 꼭 필요하다!
            
            if let daysString = formatter.string(from: date, to: self) {
                dprint("-\(daysString)만큼 차이남") // 2년 4개월 14일
                
            }
            let calendar = Calendar(identifier: .gregorian)
            let testOffSetComps = calendar.dateComponents([.day, .hour], from:date, to:self)
            if case let (d?, h?) = (testOffSetComps.day, testOffSetComps.hour) {
                dprint("TEST d : \(d) || \(h)")
                var returnStr = ""
                
                if d > 7 {
                    returnStr = "\(d / 7)주 전"
                }else{
                    returnStr = "\(d)일 전"
                }
                return returnStr
            }
            let offsetComps = calendar.dateComponents([.year,.month,.day], from:date, to:self)
            if case let (y?, m?, d?) = (offsetComps.year, offsetComps.month, offsetComps
                .day) {
              print("\(y)년\(m)월\(d)일만큼 차이남")
            }
            //let xmas = dateFormatter.date(from:"2018-12-25")!
            let wd = calendar.dateComponents([.weekday], from: date)
            if let wd = wd.weekday {
              print(wd)
            }
            return nil
        }
    }
}

//from stackoverflow - 안전하게 사용하기 위함.
extension Collection {

    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class ImageLoader {
    
    let cache = NSCache<NSString, AnyObject>()

    class var sharedLoader : ImageLoader {
    struct Static {
        static let instance : ImageLoader = ImageLoader()
        }
        return Static.instance
    }
    
    func imageForUrl(urlString: String, completionHandler: @escaping (_ image: UIImage?, _ url: String) -> ()) {
        
        DispatchQueue.global(qos: .background).async {
        
            let data: NSData? = self.cache.object(forKey: urlString as NSString) as? NSData
            
            if let goodData = data {
                let image = UIImage(data: goodData as Data)
                DispatchQueue.main.async {
                    completionHandler(image, urlString)
                }
                return
            }
            
            let session = URLSession.shared
            let request = URLRequest(url: URL(string: urlString)!);
            
            session.dataTask(with: request) { data, response, error in
                
                if (error != nil) {
                    completionHandler(nil, urlString)
                    return
                }
                
                if let data = data{
                    let image = UIImage(data: data)
                    self.cache.setObject(data as AnyObject, forKey: urlString as NSString)
                    DispatchQueue.main.async {
                        completionHandler(image, urlString)
                    }
                }
            }.resume()
            
        }
    }
}


//debug시에만 print 보이도록 하기 위함.
public func dprint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    let output = items.map { "\($0)" }.joined(separator: separator)
    Swift.print(output, terminator: terminator)
    #endif
}
/*
class ImageLoader {
    
    let cache = NSCache<NSString, AnyObject>()

    class var sharedLoader : ImageLoader {
    struct Static {
        static let instance : ImageLoader = ImageLoader()
        }
        return Static.instance
    }
    
    func imageForUrl(urlString: String, completionHandler: @escaping (_ image: UIImage?, _ url: String) -> ()) {
        
        DispatchQueue.global(qos: .background).async {
        
            let data: NSData? = self.cache.object(forKey: urlString as NSString) as? NSData
            
            if let goodData = data {
                let image = UIImage(data: goodData as Data)
                DispatchQueue.main.async {
                    completionHandler(image, urlString)
                }
                return
            }
            
            let session = URLSession.shared
            let request = URLRequest(url: URL(string: urlString)!);
            
            session.dataTask(with: request) { data, response, error in
                
                if (error != nil) {
                    completionHandler(nil, urlString)
                    return
                }
                
                if let data = data{
                    let image = UIImage(data: data)
                    self.cache.setObject(data as AnyObject, forKey: urlString as NSString)
                    DispatchQueue.main.async {
                        completionHandler(image, urlString)
                    }
                }
            }.resume()
            
        }
    }
}
*/
