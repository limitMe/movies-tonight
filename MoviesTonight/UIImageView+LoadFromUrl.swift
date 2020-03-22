//
//  String+l10n.swift
//  MoviesTonight
//
//  Created by Dian Zhong on 20/08/2017.
//
//

import UIKit

extension UIImageView{
    
    func setImageFromURl(stringImageUrl url: String){
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}
