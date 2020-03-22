//
//  ShowTimeModel.swift
//  MoviesTonight
//
//  Created by Dian Zhong on 20/08/2017.
//
//

import Foundation
import SwiftyJSON

class ShowTimeRecord {
    
    var name: String!;
    var start_time: String!;
    var end_time: String!;
    var channel: String!;
    var rating: String?;

    init(name: String!, start_time: String!, end_time: String!, channel: String!, rating: String?){
        self.name = name;
        self.start_time = start_time;
        self.end_time = end_time;
        self.channel = channel;
        self.rating = rating;
    }
    
}

class ShowTimeModel {
    
    var showtimes: Array<ShowTimeRecord>!;
    
    init(){
        self.showtimes = Array<ShowTimeRecord>();
    }
    
    func loadShowTimes(from: Int, completeHandler:@escaping (Bool, String?) -> (Void)){
        let url = NetworkManager.sharedInstance.whatsbeefbaseUrl + String(from);
        NetworkManager.sharedInstance.loadJson(url: url).then{ result -> Void in
            if result["results"] != JSON.null {
                for element in result["results"].arrayValue {
                    let newRecord = ShowTimeRecord(name: element["name"].stringValue, start_time: element["start_time"].stringValue, end_time: element["end_time"].stringValue, channel: element["channel"].stringValue, rating: element["rating"].stringValue);
                    self.showtimes.append(newRecord);
                }
                completeHandler(true, nil);
            } else if result["count"] != JSON.null{
                completeHandler(true, "Error: no more shows!");
            }
            }.catch{error -> Void in
                completeHandler(false, error.localizedDescription);
        }
    }
}
