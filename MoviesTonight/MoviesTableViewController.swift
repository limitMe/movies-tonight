//
//  MoviesTableViewController.swift
//  MoviesTonight
//
//  Created by Dian Zhong on 20/08/2017.
//
//

import UIKit

class MoviesTableViewController: UITableViewController {
    
    //MARK:--------------------------Variables and Constants------------------------------
    
    var showtimeModel: ShowTimeModel!;
    var activityIndicator: LoadMoreActivityIndicator!;
    weak var scrollViewOfLoadingMore: UIScrollView?;
    
    //MARK:-----------------------------UI Lifecycle--------------------------------------
    override func viewDidLoad() {
        
        //Nav bar color and title
        var barBackgroundImage = UIImage(named: "backgroundColor");
        barBackgroundImage = barBackgroundImage?.stretchableImage(withLeftCapWidth: Int(barBackgroundImage!.size.width / 2.0), topCapHeight: 0);
        self.navigationController?.navigationBar.setBackgroundImage(barBackgroundImage, for: .default);
        self.title = "My Movies".localized;
        
        //Tableview apperance
        tableView.dataSource = self;
        tableView.separatorStyle = .none;
        
        //Pull to refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self,
                                      action: #selector(MoviesTableViewController.pullToRefreshHandler),
                                      for: .valueChanged)
        self.tableView.addSubview(self.refreshControl!)
        
        //Drag to load more
        tableView.tableFooterView = UIView();
        activityIndicator = LoadMoreActivityIndicator(tableView: tableView, spacingFromLastCell: 10, spacingFromLastCellWhenLoadMoreActionStart: 60);
        
        //Get the initial web data
        self.showtimeModel = ShowTimeModel();
        loadFromWhatsBeef(start: 0);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let rowNumber = sender as! Int;
            let detailVC = segue.destination as! MovieDetailViewController;
            detailVC.movieName = self.showtimeModel.showtimes[rowNumber].name!;
            detailVC.timePeriod = self.showtimeModel.showtimes[rowNumber].start_time + " - " +
                self.showtimeModel.showtimes[rowNumber].end_time;
        }
    }
    
    //MARK:--------------------------Table View DataSource--------------------------------
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showtimeModel == nil || showtimeModel.showtimes == nil {
            return 0;
        } else {
            return showtimeModel.showtimes.count;
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MovieTableViewCell;
        cell.movieTitle.text = self.showtimeModel.showtimes[indexPath.row].name;
        cell.movieShowTime.text = self.showtimeModel.showtimes[indexPath.row].start_time + " - " +
            self.showtimeModel.showtimes[indexPath.row].end_time;
        cell.channelImageView.image = UIImage(named: "channel_" + self.showtimeModel.showtimes[indexPath.row].channel);
        if self.showtimeModel.showtimes[indexPath.row].rating == "" {
            cell.ratingImageView.image = UIImage(named: "rating_NR");
            cell.ratingImageWidth.constant = UIImage(named: "rating_NR")!.size.width;
        } else {
            cell.ratingImageView.image = UIImage(named: "rating_" + self.showtimeModel.showtimes[indexPath.row].rating!);
            cell.ratingImageWidth.constant = UIImage(named: "rating_" + self.showtimeModel.showtimes[indexPath.row].rating!)!.size.width;
        }
        return cell;
    }
    
    func loadFromWhatsBeef(start: Int){
        showtimeModel.loadShowTimes(from: start, completeHandler: { suc, errMsg in
            if suc {
                self.tableView.reloadData();
                //If fromScrollView, then I should dismiss the loading icon in UIScrollView
                if self.scrollViewOfLoadingMore != nil {
                    self.activityIndicator?.loadMoreActionFinshed(scrollView: self.scrollViewOfLoadingMore!);
                    self.scrollViewOfLoadingMore = nil;
                }
            }
        });
    }
    
    //Only when we have the new data, can we replace the showtimeModel
    @objc func pullToRefreshHandler() {
        let newShowtimeModel = ShowTimeModel();
        newShowtimeModel.loadShowTimes(from: 0, completeHandler: {suc, errMsg in
            if suc && newShowtimeModel.showtimes.count != 0 {
                self.showtimeModel = newShowtimeModel;
                self.refreshControl!.endRefreshing();
                self.tableView.reloadData();
            }
        })
    }
    
    func dragToLoadMoreHandle(fromScrollView: UIScrollView){
        loadFromWhatsBeef(start: self.showtimeModel.showtimes.count);
    }
    
    //MARK:--------------------------Other Table View Delegate-----------------------------
    override func numberOfSections(in tableView: UITableView) -> Int {
        //The API only contains movies in one day, that's why this is movies tonight
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0;
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0;
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var preHeader: UITableViewHeaderFooterView?;
        preHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "customHeader");
        
        guard let header = preHeader else {
            preHeader = UITableViewHeaderFooterView(reuseIdentifier: "customHeader");
            preHeader!.textLabel?.text = "TONIGHT".localized;
            return preHeader;
        }
        header.textLabel?.text="TONIGHT".localized;
        return header;
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView;
        header.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold)
        header.textLabel?.textColor = UIColor.black;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: indexPath.row);
        tableView.deselectRow(at: indexPath, animated: false);
    }
    
    //Drag to load more
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y;
        if currentOffsetY + scrollView.frame.size.height  > scrollView.contentSize.height
            &&  self.refreshControl!.isRefreshing == false {
            activityIndicator.scrollViewDidScroll(scrollView: scrollView) {
                
                DispatchQueue.global(qos: .utility).async {
                    self.dragToLoadMoreHandle(fromScrollView: scrollView);
                    self.scrollViewOfLoadingMore = scrollView;
                }
            }
        }
    }
    
    //MARK:----------------------------Other UI Settings-----------------------------------
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent;
    }
    
}
