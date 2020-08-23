//
//  AppStoreDetailViewController.swift
//  KakaoProject
//
//  Created by Dannian Park on 2020/08/23.
//  Copyright © 2020 Dannian Park. All rights reserved.
//

import Foundation
import UIKit
class AppStoreDetailViewController: UIViewController {
    
    @IBOutlet weak var IMVIcon: UIImageView!
    
    @IBOutlet weak var LBName: UILabel!
    @IBOutlet weak var LBServiceCorp: UILabel!
    @IBOutlet weak var BTNOpen: UIButton!
    @IBOutlet weak var BTNMore: UIButton!
    
    @IBOutlet weak var LBRatePoint: UILabel!
    @IBOutlet weak var RatingDisplay: FloatRatingView!
    @IBOutlet weak var LBChartRank: UILabel!
    @IBOutlet weak var LBAge: UILabel!
    
    @IBOutlet weak var LBReviewerCount: UILabel!
    @IBOutlet weak var LBChartRankTitle: UILabel!
    @IBOutlet weak var LBAgeTitle: UILabel!
    
    @IBOutlet weak var UIVDescContainer: UIView!
    
    @IBOutlet weak var LBNewFeature: UILabel!
    @IBOutlet weak var LBVersion: UILabel!
    @IBOutlet weak var BTNVersionRecord: UIButton!
    @IBOutlet weak var LBUpdateTime: UILabel!
    
    @IBOutlet weak var UIVBorderForDesc: UIView!
    
    @IBOutlet weak var LBDescription: UILabel!
    @IBOutlet weak var BTNShowMore: UIButton!
    
    @IBOutlet weak var STVImageContainer: UIStackView!
    
    @IBOutlet weak var UIVImageContainer: UIView!
    
    @IBOutlet var Const_ShowMoreHeight: NSLayoutConstraint! // default 180
    
    @IBOutlet weak var Const_DescBottom: NSLayoutConstraint! // default >= 0
    
    private var showMoreState: Bool = false
    
    
    var appData: AppSearchResponse.AppSearchData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
        self.dataInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dprint("willAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dprint("DidAppear")
        //animate in here
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dprint("willDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dprint("didDisappear")
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        dprint("will Move : \(parent)")
        if let _ = parent {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }else{
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        dprint("did move : \(parent)")
        if let _ = parent {
            
            //self.navigationController?.navigationBar.prefersLargeTitles = false
            self.Const_ShowMoreHeight.constant = 180
            self.UIVBorderForDesc.isHidden = false
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }) { (complete) in
                dprint("self. Const_DescBottom: \(self.Const_DescBottom.constant) || \(self.Const_DescBottom)")
                dprint("check height : \(self.LBDescription.bounds.height) 110")
                if self.LBDescription.bounds.height < 110 {
                    //self.Const_DescBottom.isActive = false
                    //self.Const_DescBottom_750.isActive = true
                    self.showMoreDisable(true)
                }else{
                    //self.Const_ShowMoreHeight.isActive = false
                    self.showMoreDisable(false)
                }
            }
        }else{
            //self.navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    deinit {
        
    }
    
    private func commonInit(){
        self.IMVIcon.layer.masksToBounds = true
        self.IMVIcon.layer.cornerRadius = 10
        
        self.LBName.font = .systemFont(ofSize: 18, weight: .bold)
        self.LBName.textColor = .black
        self.LBName.numberOfLines = 2
        self.LBName.adjustsFontSizeToFitWidth = true
        self.LBName.minimumScaleFactor = 0.4
        
        self.LBServiceCorp.font = .systemFont(ofSize: 10, weight: .light)
        self.LBServiceCorp.textColor = .lightGray
        self.LBServiceCorp.numberOfLines = 1
        self.LBServiceCorp.adjustsFontSizeToFitWidth = true
        self.LBServiceCorp.minimumScaleFactor = 0.4
        
        self.BTNOpen.layer.masksToBounds = true
        self.BTNOpen.layer.cornerRadius = self.BTNOpen.bounds.height / 2
        self.BTNOpen.backgroundColor = .systemBlue
        self.BTNOpen.setTitleColor(.white, for: .normal)
        self.BTNOpen.setTitle("열기", for: .normal)
        
        self.BTNMore.tintColor = .systemBlue
        self.BTNMore.setTitle(nil, for: .normal)
        self.BTNMore.setImage(UIImage(systemName: "ellipsis.circle.fill"), for: .normal)
        
        self.LBRatePoint.font = .systemFont(ofSize: 18, weight: .bold)
        self.LBRatePoint.textColor = .lightGray
        
        self.RatingDisplay.tintColor = .lightGray
        
        self.LBChartRank.font = .systemFont(ofSize: 18, weight: .bold)
        self.LBChartRank.textColor = .lightGray
        
        self.LBAge.font = .systemFont(ofSize: 18, weight: .bold)
        self.LBAge.textColor = .lightGray
        
        self.LBReviewerCount.font = .systemFont(ofSize: 12, weight: .light)
        self.LBReviewerCount.textColor = .lightGray
        
        self.LBChartRankTitle.font = .systemFont(ofSize: 12, weight: .light)
        self.LBChartRankTitle.textColor = .lightGray
        
        self.LBAgeTitle.font = .systemFont(ofSize: 12, weight: .light)
        self.LBAgeTitle.textColor = .lightGray
        
        self.LBNewFeature.font = .systemFont(ofSize: 18, weight: .bold)
        self.LBNewFeature.textColor = .black
        
        
        self.BTNVersionRecord.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        
        self.LBVersion.font = .systemFont(ofSize: 12, weight: .light)
        self.LBVersion.textColor = .lightGray
        
        self.LBUpdateTime.font = .systemFont(ofSize: 12, weight: .light)
        self.LBUpdateTime.textColor = .lightGray
        
        
        self.LBDescription.font = .systemFont(ofSize: 12, weight: .regular)
        self.LBDescription.textColor = .black
        self.LBDescription.numberOfLines = 0
        
        self.BTNShowMore.backgroundColor = .white
        
        self.UIVBorderForDesc.isHidden = true
        
        self.BTNVersionRecord.setTitle("버전 기록", for: .normal)
        self.LBAgeTitle.text = "연령"
        self.LBNewFeature.text = "새로운 기능"
        self.BTNShowMore.setTitle("더 보기", for: .normal)
        
        self.Const_ShowMoreHeight.constant = 0
        
        self.showMoreDisable(true)
    }
    
    private func dataInit() {
        guard let _data = self.appData else {self.goBack(); return}
        //self.IMVIcon.image
        ImageLoader.sharedLoader.imageForUrl(urlString: _data.icon) { (image, url) in
            self.IMVIcon.image = image
        }
        self.STVImageContainer.arrangedSubviews.forEach { (element) in
            element.removeFromSuperview()
        }
        _data.media.forEach { (element) in
            ImageLoader.sharedLoader.imageForUrl(urlString: element) { (image, url) in
                guard let _image = image else {return}
                let imageView = UIImageView()
                imageView.image = _image
                imageView.layer.masksToBounds = true
                imageView.layer.cornerRadius = 15
                NSLayoutConstraint.activate([
                    NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 280),
                    NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: _image.size.width * (280 / _image.size.height))
                ])
                
                self.STVImageContainer.addArrangedSubview(imageView)
            }
        }
        
        self.LBName.text = _data.name
        self.LBServiceCorp.text = _data.artistName
        self.LBRatePoint.text = String(format: "%.1f",  _data.averageUserRating)
        self.RatingDisplay.rating = Double(_data.averageUserRating)
        self.LBReviewerCount.text = "\(String(_data.userRatingCount).convertNumberToSting())개의 평가"
        self.LBAge.text = _data.advRating
        
        self.LBChartRank.text = "#" // data상에 rank 파라미터가 보이지 않음. 확인 필요
        
        //self.LBChartRankTitle.text =
        var str = ""
        _data.genres.forEach { (element) in
            if !str.isEmpty {
                str = str + ", \(element)"
            }else{
                str = "\(element)"
            }
        }
        self.LBChartRankTitle.text = str
        self.LBDescription.text = _data.description
        self.LBVersion.text = "버전 " + _data.version
        self.LBUpdateTime.text = Date().stringToStringWithToday(targetDateStr: _data.currentVersionReleaseDate, format: "yyyy-MM-dd'T'HH:mm:ss'Z'")
    }
    
    @IBAction func ActionShowMore(_ sender: UIButton) {
        //showMoreState
        self.showMoreState = !self.showMoreState
        self.showMoreActive(self.showMoreState)
    }
    
    private func showMoreDisable(_ disable: Bool) {
        self.BTNShowMore.isHidden = disable
    }
    
    private func showMoreActive(_ isDeactive: Bool) {
        self.Const_ShowMoreHeight.isActive = !isDeactive
        self.BTNShowMore.setTitle((!isDeactive ? "더 보기" : "숨기기"), for: .normal)
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded()
        }) { (complete) in
            
        }
    }
    
}

extension AppStoreDetailViewController {
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
