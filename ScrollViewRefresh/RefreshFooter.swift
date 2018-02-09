//
//  GRefreshFooter.swift
//  GRefresh
//
//  Created by hyku on 2018/1/30.
//  Copyright © 2018年 hyku. All rights reserved.
//

import UIKit

open class RefreshFooter: RefreshComponent {
    
    /// 是否自动刷新（默认是）
    var automaticallyRefresh = true
    
    /// 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新)
    var triggerAutomaticallyRefreshPercent:CGFloat = 0.0
    
    override var state: RefreshState{
        didSet{
            if oldValue == state {
                return
            }
            super.state = state
            
            if (state == .refreshing) {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    self.executeRefreshingCallback()
                })

            } else if (state == .noMoreData || state == .idle) {
                if (.refreshing == oldValue) {
                    if (self.endRefreshingCompletionBlock != nil) {
                        self.endRefreshingCompletionBlock!();
                    }
                }
            }
        }
    }
    
    open override var isHidden: Bool{
        didSet{
            let lastHidden = self.isHidden
            super.isHidden = isHidden
            
            if lastHidden == false && isHidden == true{
                self.state = .idle
                self.scrollView!.insetBottom -= self.height
            }else if lastHidden == true && isHidden == false{
                self.scrollView!.insetBottom += self.height
                
                // 设置位置
                self.y = self.scrollView!.contentHeight
            }
            
        }
    }
    
    // MARK: - 构造方法
    class func footerWithRefreshingBlock(refreshingBlock:@escaping RefreshComponentRefreshingBlock) -> RefreshFooter {
        let footer:RefreshFooter = self.init()
        footer.refreshingBlock = refreshingBlock
        return footer;
    }
    
    /// 是否加载完毕
    public func setNoMoreData(noMoreData:Bool) {
        if noMoreData == true{
            self.state = .noMoreData
        }else{
            self.state = .idle
        }
    }
    
    // MARK: - 实现父类的方法
    override func prepare() {
        super.prepare()
        
        self.height = RefreshConst.refreshFooterHeight
        
        // 默认底部控件100%出现时才会自动刷新
        self.triggerAutomaticallyRefreshPercent = 1.0
        
        // 设置为默认状态
        self.automaticallyRefresh = true
        
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        // 新的父控件
        if newSuperview != nil {
            if self.isHidden == false {
                self.scrollView?.insetBottom += self.height;
            }
            // 设置位置
            self.y = self.scrollView!.contentHeight;
        }
        // 被移除了
        else{
            if (self.isHidden == false) {
                self.scrollView!.insetBottom -= self.height;
            }
        }
    }
    
    override func scrollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDidChange(change: change)
        // 设置位置
        self.y = self.scrollView!.contentHeight;
    }
    
    override func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]) {
        super.scrollViewContentOffsetDidChange(change: change)

        if self.state != .idle || self.automaticallyRefresh == false || self.y == 0{
            return
        }
        
        // 内容超过一个屏幕
        if self.scrollView!.insetTop + self.scrollView!.contentHeight > self.scrollView!.height{
            
            let tmp = self.scrollView!.contentHeight - self.scrollView!.height + self.height * self.triggerAutomaticallyRefreshPercent + self.scrollView!.insetBottom - self.height
            
            if self.scrollView!.offsetY >= tmp{
                
                // 防止手松开时连续调用
                let old = change[NSKeyValueChangeKey.oldKey] as! CGPoint
                let new = change[NSKeyValueChangeKey.newKey] as! CGPoint
                if new.y <= old.y{
                    return
                }
                // 当底部刷新控件完全出现时，才刷新
                self.beginRefreshing();
            }
        }
    }
    
    override func scrollViewPanStateDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewPanStateDidChange(change: change)
        if self.state != .idle {
            return
        }
        
        //手松开
        if self.scrollView?.panGestureRecognizer.state == UIGestureRecognizerState.ended {
            
            // 不够一个屏幕
            if (self.scrollView?.insetTop)! + (self.scrollView?.contentHeight)! <= (self.scrollView?.height)! {
                // 向上拽
                if (self.scrollView?.offsetY)! >= -(self.scrollView?.insetTop)! {
                    self.beginRefreshing()
                }
            }else{
                if (self.scrollView?.offsetY)! >= (self.scrollView?.contentHeight)! + (self.scrollView?.insetBottom)! - (self.scrollView?.height)! {
                    self.beginRefreshing()
                }
            }
        }
    }
}
