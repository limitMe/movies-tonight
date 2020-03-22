//
//  MovieDetailViewController.swift
//  MoviesTonight
//
//  Created by Dian Zhong on 20/08/2017.
//
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    //External variable
    var movieName: String!;
    var timePeriod: String!;
    
    //Internal UI Outlet
    @IBOutlet weak var movieCover: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieShowTime: UILabel!
    @IBOutlet weak var movieDescription: UITextView!
    
    let movieDetailModel = MovieDetailModel();
    
    override func viewDidLoad() {
        movieTitle.text = movieName;
        movieShowTime.text = timePeriod;
        self.title = movieName;
        
        movieDetailModel.loadMovieDetail(withName: movieName, completeHandler: {suc, err in
            if suc {
                self.movieDescription.text = self.movieDetailModel.movieDetail!.describe!;
                self.movieCover.setImageFromURl(stringImageUrl: self.movieDetailModel.movieDetail!.pictureUrl!)
            }
        });
    }
    
}
