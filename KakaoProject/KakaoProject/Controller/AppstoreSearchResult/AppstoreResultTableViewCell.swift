//
//  AppstoreResultTableViewCell.swift
//  KakaoProject
//
//  Created by Dannian Park on 2020/08/22.
//  Copyright © 2020 Dannian Park. All rights reserved.
//

import UIKit

class AppstoreResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var IMVIcon: UIImageView!
    @IBOutlet weak var LBCorp: UILabel!
    @IBOutlet weak var LBName: UILabel!
    @IBOutlet weak var LBRateCount: UILabel!
    
    @IBOutlet weak var RatingView: FloatRatingView!
    
    @IBOutlet weak var STVScreenShots: UIStackView!
    @IBOutlet weak var BTNSetting: UIButton!
    
    var imageviewsForScreenShot : [UIImageView] {
        return self.STVScreenShots.arrangedSubviews as! [UIImageView]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.IMVIcon.layer.masksToBounds = true
        self.IMVIcon.layer.cornerRadius = 15
        self.LBName.font = UIFont.systemFont(ofSize: 20, weight: .black)
        self.LBRateCount.textColor = UIColor.lightGray
        self.LBRateCount.font = .systemFont(ofSize: 13, weight: .light)
        self.LBCorp.font = .systemFont(ofSize: 13, weight: .light)
        self.RatingView.type = .floatRatings
        self.BTNSetting.layer.masksToBounds = true
        self.BTNSetting.layer.cornerRadius = self.BTNSetting.bounds.height / 2
        
        self.RatingView.tintColor = .darkGray
        
        self.BTNSetting.setTitle("열기", for: .normal)
    }
    
    func setData(appData : AppSearchResponse.AppSearchData) {
        self.LBName.text = appData.name
        self.LBCorp.text = appData.artistName
        self.IMVIcon.downloaded(from: appData.icon)
        self.RatingView.rating = Double(appData.averageUserRating)
        self.LBRateCount.text = "\(appData.userRatingCount)".convertNumberToSting()
        
        if appData.screenshots.count > 0 {
            self.STVScreenShots.isHidden = false
            for (index, screenShot) in appData.screenshots.enumerated(){
                dprint("Check Data image : \(screenShot)")
                //screenshotImageViews[safe: index]?.kf.setImage(with: URL(string: screenshot))
                ImageLoader.sharedLoader.imageForUrl(urlString: screenShot) { (image, url) in
                    DispatchQueue.main.async {
                        guard let _image = image else {return}
                        let imv = self.imageviewsForScreenShot[safe: index]
                        imv?.layer.masksToBounds = true
                        imv?.layer.cornerRadius = 15
                        if _image.size.width < _image.size.height {
                            imv?.contentMode = .scaleAspectFit
                        }else{
                            imv?.contentMode = .scaleAspectFill
                        }
                        imv?.image = _image
                    }
                }
            }
        }else{
            self.STVScreenShots.isHidden = true
        }
        dprint("Check stData : \(appData.icon)")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cancelDownload() {
        
    }
}
