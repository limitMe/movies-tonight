//
//  NetworkManager.swift
//  MoviesTonight
//
//  Created by Dian Zhong on 20/08/2017.
//
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON

enum NetworkType {
    case product;
    case mock;
    case compare;
}

final class NetworkManager {
    
    private init(){
    }
    
    static let sharedInstance: NetworkManager = NetworkManager();
    
    let whatsbeefbaseUrl = "https://www.whatsbeef.net/wabz/guide.php?start=0";
    let limAUbaseUrl = "http://47.91.45.130:8088/api/movie/";
    
    func loadJson(url: URLConvertible, method: HTTPMethod = .get, paras: [String: Any]? = nil, headers: HTTPHeaders? = nil) -> Promise<JSON>{
        return Promise { fulfill, reject in
            Alamofire.request(url, method: method, parameters: paras, encoding: URLEncoding.default, headers: headers)
                .validate()
                .responseJSON{ response in
                    switch response.result {
                    case .success(let dict):
                        let json = JSON(dict)
                        fulfill(json);
                    case .failure(let error):
                        reject(error);
                    }
            }
        }
    }
}

