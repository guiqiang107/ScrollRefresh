//
//  GRefreshNormalHeader.swift
//  GRefresh
//
//  Created by hyku on 2018/1/30.
//  Copyright © 2018年 hyku. All rights reserved.
//

import UIKit

public class RefreshNormalHeader: RefreshHeader {
    
    var pullDownToRefresh = RefreshConst.pullDownToRefresh
    var releaseToRefresh = RefreshConst.releaseToRefresh
    var refreshing = RefreshConst.refreshing
    
    lazy var arrowView: UIImageView = {
        let arrowIndicator = UIImageView()
        arrowIndicator.image = UIImage(named: "arrow@2x.png", in: Bundle(for: RefreshNormalHeader.self), compatibleWith: nil)
        return arrowIndicator
    }()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = .gray
        return indicator
    }()

    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.init(white: 0.5, alpha: 1.0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.messageLabel)
        self.addSubview(self.arrowView)
        self.addSubview(self.loadingView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        self.height = 60
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        let center = CGPoint(x: frame.width * 0.5 - 60 , y: frame.height * 0.5)
        self.arrowView.frame = CGRect(x: 0, y: 0, width: 0.375 * 30, height: 30)
        self.arrowView.center = center
        
        self.loadingView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        self.loadingView.center = center
        
        self.messageLabel.frame = self.bounds
    }
    
    override var state: RefreshState{
        didSet{
            super.state = state
//            print("oldValue:",oldValue,"state:",state)
            if state == .idle {
                self.loadingView.isHidden = true
                self.loadingView.stopAnimating()
                self.arrowView.isHidden = false
                self.messageLabel.text =  self.pullDownToRefresh
                UIView.animate(withDuration: RefreshConst.fastAnimationDuration, animations: {
                    self.arrowView.transform = CGAffineTransform.identity
                })
            }
            else if(state == .pulling){
                self.loadingView.isHidden = true
                self.messageLabel.text = self.pullDownToRefresh
                guard arrowView.transform == CGAffineTransform(rotationAngle: CGFloat(-Double.pi+0.000001))  else{
                    return
                }
                UIView.animate(withDuration: RefreshConst.fastAnimationDuration, animations: {
                    self.arrowView.transform = CGAffineTransform.identity
                })
            }
            else if(state == .willRefresh){
                self.messageLabel.text = self.releaseToRefresh
                self.loadingView.isHidden = true
                guard arrowView.transform == CGAffineTransform.identity else{
                    return
                }
                UIView.animate(withDuration: RefreshConst.fastAnimationDuration, animations: {
                    self.arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi+0.000001))
                })
            }
            else if(state == .refreshing){
                
                self.arrowView.isHidden = true
                self.loadingView.isHidden = false
                self.loadingView.startAnimating()
                self.messageLabel.text = self.refreshing
            }
        }
    }
    
    /// 下拉时
    override var pullingPercent: CGFloat{
        didSet{
           
        }
    }
    
    override func endRefreshing() {
        super.endRefreshing()
    }
}
