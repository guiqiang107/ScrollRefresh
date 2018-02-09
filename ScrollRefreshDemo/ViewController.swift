//
//  ViewController.swift
//  ScrollViewRefresh
//
//  Created by hyku on 2018/2/6.
//  Copyright © 2018年 hyku. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    var tableView : UITableView!
    var models = [1,2,3,4,5,6,7]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.orange
        
        //普通下拉刷新
//        self.tableView.refreshHeader = RefreshNormalHeader.headerWithRefreshingBlock {
//            self.headerRefresh()
//        }
        
        //自定义自己的gif刷新
        self.tableView.refreshHeader = RefreshGifHeader.headerWithRefreshingBlock {
            self.headerRefresh()
        }

        self.tableView.refreshFooter = RefreshNormalFooter.footerWithRefreshingBlock {
            self.footerRefresh()
        }
        
    }
    
    func headerRefresh() {
        perform(#selector(headerEndRefresing), with: nil, afterDelay: 2)
    }
    
    @objc func headerEndRefresing() {
        self.tableView.refreshFooter?.setNoMoreData(noMoreData: false)
        self.tableView.refreshHeader?.endRefreshing()
        
        self.models.removeAll()
        self.models = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
        self.tableView.reloadData()
    }
    
    func footerRefresh() {
        perform(#selector(footerEndRefresing), with: nil, afterDelay: 2)
    }
    @objc func footerEndRefresing() {
        self.models += [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]
        self.tableView.refreshFooter?.endRefreshing()
        
        if self.models.count>50 {
            self.tableView.refreshFooter?.setNoMoreData(noMoreData: true)
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "\(models[(indexPath as NSIndexPath).row])"
        cell?.backgroundColor = UIColor.lightGray
        return cell!
    }
    
    
}

