//
//  RefreshNormalFooter.swift
//  Mercku
//
//  Created by hyku on 2018/2/6.
//  Copyright © 2018年 hyku. All rights reserved.
//

import UIKit

public class RefreshNormalFooter: RefreshFooter {

    var pullUpToLoaddingText = RefreshConst.pullUpToLoadding
    var loaddingText = RefreshConst.loadding
    var noMoreDataText = RefreshConst.noMoreData
    
    lazy var loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = .white
        return indicator
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.init(white: 0.5, alpha: 1.0)
        label.text = self.pullUpToLoaddingText
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.messageLabel)
        self.addSubview(self.loadingView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        self.messageLabel.frame = self.bounds
        
        let center = CGPoint(x: frame.width * 0.5 - 60 , y: frame.height * 0.5)
        self.loadingView.center = center
    }
    
    override var state: RefreshState{
        didSet{
            super.state = state
            
            if (state == .idle) {
                self.messageLabel.text = self.pullUpToLoaddingText
                self.loadingView.stopAnimating()
            } else if (state == .refreshing) {
                self.messageLabel.text = self.loaddingText
                self.loadingView.startAnimating()
            }else if (state == .noMoreData) {
                self.messageLabel.text = self.noMoreDataText
                self.loadingView.stopAnimating()
            }
        }
    }

}
