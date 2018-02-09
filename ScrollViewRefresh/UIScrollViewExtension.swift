//
//  UIScrollViewExtension.swift
//  GRefresh
//
//  Created by hyku on 2018/1/30.
//  Copyright © 2018年 hyku. All rights reserved.
//

import UIKit
import Foundation

public extension UIScrollView{
    
    
    /// 滚动视图的下拉刷新Header
    public var refreshHeader: RefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &RefreshConst.associatedObjectScrollViewRefreshHeader) as? RefreshHeader
        }
        set {
            
            if (newValue != self.refreshHeader) {
                
                // 删除旧的，添加新的
                self.refreshHeader?.removeFromSuperview()
                self.insertSubview(newValue!, at: 0)
                
                // 存储新的
                self.willChangeValue(forKey: "refreshHeader") // KVO
                objc_setAssociatedObject(self, &RefreshConst.associatedObjectScrollViewRefreshHeader, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.didChangeValue(forKey: "refreshHeader") // KVO
            }
           
        }
    }
    
    /// 滚动视图的上拉加载Footer
    public var refreshFooter: RefreshFooter? {
        get {
            return objc_getAssociatedObject(self, &RefreshConst.associatedObjectScrollViewRefreshFooter) as? RefreshFooter
        }
        set {
            
            if (newValue != self.refreshFooter) {
                
                // 删除旧的，添加新的
                self.refreshFooter?.removeFromSuperview()
                self.insertSubview(newValue!, at: 0)
                
                // 存储新的
                self.willChangeValue(forKey: "refreshFooter") // KVO
                objc_setAssociatedObject(self, &RefreshConst.associatedObjectScrollViewRefreshFooter, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.didChangeValue(forKey: "refreshFooter") // KVO
            }
            
        }
    }
}
