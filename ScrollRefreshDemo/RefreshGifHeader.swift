//
//  GRefreshGifHeader.swift
//  GRefresh
//
//  Created by hyku on 2018/1/31.
//  Copyright © 2018年 hyku. All rights reserved.
//

import UIKit

public class RefreshGifHeader: RefreshHeader {
    
    lazy var imageView: UIImageView = {
        let animateImageView = UIImageView()
        animateImageView.image = UIImage(named: "dropdown_loading_01@2x.png")
        return animateImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        self.height = 70
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        self.imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        self.imageView.center = CGPoint(x: self.bounds.width/2.0, y: self.bounds.height/2.0)
    }
    
    override var state: RefreshState{
        didSet{
            
            super.state = state
            if(state == .refreshing){
                let images = ["dropdown_loading_01","dropdown_loading_02","dropdown_loading_03"].map { (name) -> UIImage in
                    return UIImage(named:name)!
                }
                self.imageView.animationImages = images
                self.imageView.animationDuration = Double(images.count) * 0.15
                self.imageView.startAnimating()
            }
        }
    }
    
    
    /// 下拉时
    override var pullingPercent: CGFloat{
        didSet{
            let mappedIndex = Int(self.pullingPercent * 60)
            let imageName = "dropdown_anim__000\(mappedIndex)"
            let image = UIImage(named: imageName)
            self.imageView.image = image
        }
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        self.imageView.stopAnimating()
        self.imageView.image = UIImage(named: "dropdown_loading_01@2x.png")
    }
    
}
