//
//  AppstoreResultTableViewModel.swift
//  KakaoProject
//
//  Created by Dannian Park on 2020/08/25.
//  Copyright © 2020 Dannian Park. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol AppstoreResultTableViewModelInput {
    func appSearch(string: String)
    func dataTaskCancelRequest()
}

protocol AppstoreResultTableViewModelOutput {
    var resultHandler: ((_ result : AppSearchResponse) -> Void)? {get set}
}

protocol AppstoreResultTableViewModelType {
    var inputs: AppstoreResultTableViewModelInput {get}
    var outputs: AppstoreResultTableViewModelOutput {get}
}

class AppstoreResultTableViewModel : AppstoreResultTableViewModelType, AppstoreResultTableViewModelInput, AppstoreResultTableViewModelOutput{
    
    private var dataTask : URLSessionDataTask?
    
    init() {
        dprint("init AppstoreResultTableViewModel")
    }
    
    deinit {
        dprint("deinit AppstoreResultTableViewModel")
    }
    /*
    response : Optional(<NSHTTPURLResponse: 0x6000015075e0> { URL: https://itunes.apple.com/search?term=Kaka&entity=software&limit=10 } { Status Code: 200, Headers {
        "Cache-Control" =     (
            "max-age=86354"
        );
        "Content-Disposition" =     (
            "attachment; filename=1.txt"
        );
        "Content-Encoding" =     (
            gzip
        );
        "Content-Length" =     (
            16820
        );
        "Content-Type" =     (
            "text/javascript; charset=utf-8"
        );
        Date =     (
            "Sat, 22 Aug 2020 08:50:34 GMT"
        );
        "Strict-Transport-Security" =     (
            "max-age=31536000"
        );
        Vary =     (
            "Accept-Encoding"
        );
        "apple-originating-system" =     (
            MZStoreServices
        );
        "apple-seq" =     (
            0
        );
        "apple-timing-app" =     (
            "138 ms"
        );
        "apple-tk" =     (
            false
        );
        b3 =     (
            "cdd316e1137db2f93f4b86f660ace8fd-ddee6b2ae333a920"
        );
        "x-apple-application-instance" =     (
            2003108
        );
        "x-apple-application-site" =     (
            ST11
        );
        "x-apple-jingle-correlation-key" =     (
            ZXJRNYITPWZPSP2LQ33GBLHI7U
        );
        "x-apple-orig-url" =     (
            "https://itunes.apple.com/search?term=Kaka&entity=software&limit=10"
        );
        "x-apple-partner" =     (
            "origin.0"
        );
        "x-apple-request-uuid" =     (
            "cdd316e1-137d-b2f9-3f4b-86f660ace8fd"
        );
        "x-apple-translated-wo-url" =     (
            "/WebObjects/MZStoreServices.woa/ws/wsSearch?term=Kaka&entity=software&limit=10&urlDesc="
        );
        "x-b3-spanid" =     (
            ddee6b2ae333a920
        );
        "x-b3-traceid" =     (
            cdd316e1137db2f93f4b86f660ace8fd
        );
        "x-cache" =     (
            "TCP_MISS from a23-59-72-172.deploy.akamaitechnologies.com (AkamaiGHost/10.1.2-30481071) (-)"
        );
        "x-cache-remote" =     (
            "TCP_MISS from a104-70-122-179.deploy.akamaitechnologies.com (AkamaiGHost/10.1.2-30481071) (-)"
        );
        "x-content-type-options" =     (
            nosniff
        );
        "x-true-cache-key" =     (
            "/L/itunes.apple.com/search vcd=2897 ci2=entity=software&limit=10&term=Kaka__"
        );
        "x-webobjects-loadaverage" =     (
            0
        );
    } })
    */
    //input
    func appSearch(string: String) {
        self.dataTask?.cancel()
        let stringWithPercent = string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url = URL(string: "https://itunes.apple.com/search?term=\(stringWithPercent ?? String())&entity=software&limit=10&country=kr")!//software,iPadSoftware
        //let url = URL(string: "https://itunes.apple.com/search?term=\(encodedTerm ?? String())&entity=software,iPadSoftware&limit=10")
        self.dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            //dprint("Check data : \(data)\nresponse : \(response)\nerror : \(error)")
            guard let _data = data else {return}
            do {
                let _response = try JSONDecoder().decode(AppSearchResponse.self, from: _data)
                dprint("datatask _data : \(_data) jsonData : \(JSON(_data))")
                self.resultHandler?(_response)
            }catch {
                dprint("Error: \(error)")
            }
        })
        self.dataTask?.resume()
    }
    
    func dataTaskCancelRequest() {
        self.dataTask?.cancel()
    }
    //output
    var resultHandler: ((_ result : AppSearchResponse) -> Void)?
    
    var inputs: AppstoreResultTableViewModelInput { return self }
    var outputs: AppstoreResultTableViewModelOutput { return self }
}
