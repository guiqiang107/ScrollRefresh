//
//  GRefreshConstant.swift
//  GRefresh
//
//  Created by hyku on 2018/1/30.
//  Copyright © 2018年 hyku. All rights reserved.
//

import UIKit

class RefreshConst {
    
    static public let pullDownToRefresh: String = "下拉刷新"
    static public let releaseToRefresh: String = "释放刷新"
    static public let refreshing: String = "加载中..."
    
    static public let pullUpToLoadding: String = "上拉加载更多"
    static public let loadding: String = "加载中..."
    static public let noMoreData: String = "加载完毕"
    
    static public let keyPathContentOffset: String = "contentOffset"
    static public let keyPathContentInset: String = "contentInset"
    static public let keyPathContentSize: String = "contentSize"
    static public let keyPathPanState: String = "state"
    
    static public let fastAnimationDuration: TimeInterval = 0.25
    static public let slowAnimationDuration: TimeInterval = 0.4
    
    static public let refreshHeaderHeight :CGFloat = 50  //头部刷新普通高度
    static public let refreshFooterHeight: CGFloat = 44  //加载更多普通高度
    
    static var associatedObjectScrollViewRefreshHeader = 0    //extension中scrollView关联refreshHeader的key
    static var associatedObjectScrollViewRefreshFooter = 1    //extension中scrollView关联refreshFooter的key
}
