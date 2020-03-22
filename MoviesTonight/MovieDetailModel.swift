//
//  MovieDetailModel.swift
//  MoviesTonight
//
//  Created by Dian Zhong on 20/08/2017.
//
//

import Foundation
import SwiftyJSON

class MovieDetailRecord {
    var movieName: String!;
    var describe: String!;
    var pictureUrl: String!;
    
    init(name: String!, description: String!, pictureUrl :String!){
        self.movieName = name;
        self.describe = description;
        self.pictureUrl = pictureUrl;
    }
}

class MovieDetailModel {
    var movieDetail: MovieDetailRecord?;
    
    init(){
        
    }
    
    func loadMovieDetail(withName: String!, completeHandler:@escaping (Bool, String?) -> (Void)){
        let url = NetworkManager.sharedInstance.limAUbaseUrl + withName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!;
        NetworkManager.sharedInstance.loadJson(url: url).then{ result -> Void in
            if result != JSON.null {
                self.movieDetail = MovieDetailRecord(name: result["movieName"].stringValue,
                                                     description: result["discription"].stringValue,
                                                     pictureUrl: result["pictureUrl"].stringValue);
                completeHandler(true, nil);
                }
            }.catch{error -> Void in
                completeHandler(false, error.localizedDescription);
        }

    }
}
