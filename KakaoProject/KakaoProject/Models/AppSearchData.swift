//
//  AppSearchData.swift
//  KakaoProject
//
//  Created by Dannian Park on 2020/08/22.
//  Copyright © 2020 Dannian Park. All rights reserved.
//

import Foundation

struct AppSearchResponse: Decodable {
    var results: [AppSearchData]
    var resultCount: Int {
        get {
            return self.results.count
        }
    }
    
    struct AppSearchData: Decodable {
        var name: String
        var artistName: String
        var genre: String
        var icon: String
        var screenshots: [String]
        var description : String
        var version: String
        var advRating : String // 콘텐츠 등급
        var userRatingCount: Int // 리뷰 인원
        var averageUserRating: Float // float (별표)
        var releaseNotes: String
        var genres : [String]
        var currentVersionReleaseDate : String // 최근 릴리즈 날짜
        
        var media: [String] {
            var images = self.screenshots
            images.insert(self.icon, at: 0)
            return images
        }
        
        enum CodingKeys: String, CodingKey {
            case name = "trackName"
            case artistName = "artistName"
            case genre = "primaryGenreName"
            case icon = "artworkUrl512"
            case screenshots = "screenshotUrls"
            case description = "description"
            case version = "version"
            case advRating = "contentAdvisoryRating"
            case userRatingCount = "userRatingCount"
            case averageUserRating = "averageUserRating"
            case releaseNotes = "releaseNotes"
            case genres = "genres"
            case currentVersionReleaseDate = "currentVersionReleaseDate"
        }
    }
}

