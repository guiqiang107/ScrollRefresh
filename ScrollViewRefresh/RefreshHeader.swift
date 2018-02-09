//
//  GRefreshHeader.swift
//  GRefresh
//
//  Created by hyku on 2018/1/30.
//  Copyright © 2018年 hyku. All rights reserved.
//

import UIKit

open class RefreshHeader: RefreshComponent {
    
    var insetTDelta : CGFloat = 0.0
    
    
    // MARK: - 构造方法
    class func headerWithRefreshingBlock(refreshingBlock:@escaping RefreshComponentRefreshingBlock) -> RefreshHeader {
        let header:RefreshHeader = self.init()
        header.refreshingBlock = refreshingBlock
        return header;
    }
    
    // MARK: - 覆盖父类的方法
    override func prepare() {
        super.prepare()
        self.height = RefreshConst.refreshHeaderHeight
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
        self.y = -self.height
    }
    
    override func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]) {
        super.scrollViewContentOffsetDidChange(change: change)
        
        guard let scrollV = self.scrollView else {
            return
        }
        
        let originalInset = self.scrollViewOriginalInset!
        
        if state == .refreshing {
            guard let _ = self.window else {
                return
            }
            // 考虑SectionHeader停留时的高度
            var insetT: CGFloat = (-scrollV.offsetY > originalInset.top) ? -scrollV.offsetY : originalInset.top
            insetT = (insetT > self.height + originalInset.top) ? (self.height + originalInset.top) : insetT
            
            scrollV.insetTop = insetT
            self.insetTDelta = originalInset.top - insetT
            
            return
        }
        // 跳转到下一个控制器时，contentInset可能会变
        self.scrollViewOriginalInset = scrollV.inset
        
        // 当前的contentOffset
        let offsetY: CGFloat = scrollV.offsetY
        // 头部控件刚好出现的offsetY
        let headerInOffsetY: CGFloat = -originalInset.top
        
        // 如果是向上滚动头部控件还没出现，直接返回
        guard offsetY <= headerInOffsetY else {
            return
        }
        
        // 普通 和 即将刷新 的临界点
        let idle2pullingOffsetY: CGFloat = headerInOffsetY - self.height
        
        if scrollV.isDragging {
            switch state {
            case .idle:
                if offsetY <= headerInOffsetY {
                    self.state = .pulling
                }
            case .pulling:
                if offsetY <= idle2pullingOffsetY {
                    self.state = .willRefresh
                } else {
                    self.pullingPercent = (headerInOffsetY - offsetY) / self.height
                }
            case .willRefresh:
                if offsetY > idle2pullingOffsetY {
                    self.state = .idle
                }
            default: break
            }
        } else {
            // 停止Drag && 并且是即将刷新状态
            if state == .willRefresh {
                // 开始刷新
                self.pullingPercent = 1.0
                // 只要正在刷新，就完全显示
                if self.window != nil {
                    self.state = .refreshing
                } else {
                    // 预防正在刷新中时，调用本方法使得header inset回置失败
                    if state != .refreshing {
                        self.state = .willRefresh
                        // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
                        self.setNeedsDisplay()
                    }
                }
            }
        }
    }

    override var state: RefreshState{
        didSet{
            if oldValue == state {
                return
            }
            super.state = state
            
             // 根据状态做事情
            if state == .idle {
                if(oldValue != .refreshing){return}
                // 恢复Inset
                UIView.animate(withDuration: RefreshConst.slowAnimationDuration, animations: {
                    self.scrollView?.insetTop += self.insetTDelta
                }, completion: { (isFinish) in
                    self.pullingPercent = 0.0;
                    
                    if (self.endRefreshingCompletionBlock != nil) {
                        self.endRefreshingCompletionBlock!();
                    }
                })
            }else if(state == .refreshing){
                DispatchQueue.main.async {
                    UIView.animate(withDuration: RefreshConst.fastAnimationDuration, animations: {

                        let top: CGFloat = self.scrollViewOriginalInset!.top + self.height
                        // 增加滚动区域top
                        self.scrollView?.insetTop = top
                        // 设置滚动位置
                        self.scrollView?.contentOffset = CGPoint(x: 0, y: -top)
                    }, completion: { (isFinish) in
                        // 执行刷新操作
                        self.executeRefreshingCallback()
                    })
                }
            }
        }
    }
    
    override func endRefreshing() {
        DispatchQueue.main.async {
            self.state = .idle;
        }
    }
}
