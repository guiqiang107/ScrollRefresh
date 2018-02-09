//
//  GRefreshComponent.swift
//  GRefresh
//
//  Created by hyku on 2018/1/30.
//  Copyright © 2018年 hyku. All rights reserved.
//

import UIKit

public enum RefreshState {
    
    /// 普通闲置状态
    case idle
    
    /// 松开就可以进行刷新的状态
    case pulling
    
    /// 即将刷新的状态
    case willRefresh
    
    /// 正在刷新中的状态
    case refreshing
    
    /// 所有数据加载完毕，没有更多的数据了
    case noMoreData
}

/// 进入刷新状态的回调
typealias RefreshComponentRefreshingBlock = () -> (Void)

/// 开始刷新后的回调(进入刷新状态后的回调)
typealias RefreshComponentBeginRefreshingCompletionBlock = () -> (Void)

///  结束刷新后的回调
typealias RefreshComponentEndRefreshingCompletionBlock = () -> (Void)

open class RefreshComponent: UIView {

    ///  刷新状态 一般交给子类内部实现
    var state : RefreshState = .idle{
        
        didSet{
            /// 加入主队列的目的是等setState:方法调用完毕、设置完文字后再去布局子控件
            DispatchQueue.main.async {
                self.setNeedsLayout()
            }
        }
    }
    
    private var pan: UIPanGestureRecognizer!
    
    /// 刷新回调
    var refreshingBlock : RefreshComponentRefreshingBlock?
    
    /// 开始刷新后的回调(进入刷新状态后的回调)
    var beginRefreshingCompletionBlock : RefreshComponentBeginRefreshingCompletionBlock?
    
    /// 结束刷新的回调
    var endRefreshingCompletionBlock : RefreshComponentEndRefreshingCompletionBlock?

    /// 拉拽的百分比(交给子类重写)
    var pullingPercent : CGFloat = 0.0
    
    /// 父控件
    public var scrollView: UIScrollView?
    
    /// 记录scrollView刚开始的inset
    public var scrollViewOriginalInset: UIEdgeInsets?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
        self.state = .idle
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        self.placeSubviews()
        super.layoutSubviews()
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.state == .willRefresh {
            //预防view还没显示出来就调用了beginRefreshing
            self.state = .refreshing
        }
    }
    
    // MARK: - 刷新状态控制
    ///  进入刷新状态
    func beginRefreshing() {
        self.pullingPercent = 1.0
        if (self.window != nil) {
            self.state = .refreshing
        }else{
            // 预防正在刷新中时，调用本方法使得header inset回置失败
            if(self.state != .refreshing){
                self.state = .willRefresh
                // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
                self.setNeedsDisplay()
            }
        }
    }
    func beginRefreshing(completionBlock:@escaping RefreshComponentBeginRefreshingCompletionBlock){
        self.beginRefreshingCompletionBlock = completionBlock
        self.beginRefreshing()
    }
    
    /// 结束刷新状态
    func endRefreshing() {
        self.state = .idle
    }
    func endRefreshing(completionBlock:@escaping RefreshComponentEndRefreshingCompletionBlock){
        self.endRefreshingCompletionBlock = completionBlock
        self.endRefreshing()
    }
    
    
    /// 是否正在刷新
    func isRefreshing() -> Bool {
        return self.state == .refreshing || self.state == .willRefresh
    }
    
    
    // MARK: - 交给子类们去实现
    /// 初始化
    func prepare() {
        // 基本属性
        self.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.backgroundColor = UIColor.clear
    }
    
    func executeRefreshingCallback() {
        if ((self.refreshingBlock) != nil) {
            self.refreshingBlock!();
        }
        if ((self.beginRefreshingCompletionBlock) != nil) {
            self.beginRefreshingCompletionBlock!();
        }
    }
    
    /// 摆放子控件frame
    func placeSubviews() { }
    
    /// 当scrollView的contentOffset发生改变的时候调用
    func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]) {
        
    }
    /// 当scrollView的contentSize发生改变的时候调用 
    func scrollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?){
        
    }
    
    func scrollViewPanStateDidChange(change: [NSKeyValueChangeKey : Any]?){
        
    }
    
    // MARK: - 其他
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        // 如果不是UIScrollView，不做任何事情
        guard newSuperview is UIScrollView else {
            return
        }
        
        // 旧的父控件移除监听
        self.removeAbserver()
        
        // 新的父控件
        guard let superView = newSuperview else {
            return
        }
        
        self.width = superView.width // 设置宽度
        self.x = 0 // 设置位置
        
        // 记录UIScrollView
        self.scrollView = newSuperview as! UIScrollView?
        // 设置永远支持垂直弹簧效果
        self.scrollView?.alwaysBounceVertical = true
        // 记录UIScrollView最开始的contentInset
        self.scrollViewOriginalInset = self.scrollView?.inset
        
        self.addObserver()
    }
    
    // MARK:KVO监听
    private func addObserver() {
        scrollView?.addObserver(self, forKeyPath: RefreshConst.keyPathContentOffset, options: [.new,.old], context: nil)
        scrollView?.addObserver(self, forKeyPath: RefreshConst.keyPathContentSize, options: [.new,.old], context: nil)
        self.pan = (self.scrollView?.panGestureRecognizer)!
        self.pan.addObserver(self, forKeyPath: RefreshConst.keyPathPanState, options: [.new,.old], context: nil)
    }
    
    private func removeAbserver() {
        self.superview?.removeObserver(self, forKeyPath: RefreshConst.keyPathContentOffset)
        self.superview?.removeObserver(self, forKeyPath: RefreshConst.keyPathContentSize)
        
        if self.pan != nil {
            self.pan.removeObserver(self, forKeyPath: RefreshConst.keyPathPanState)
            self.pan = nil;
        }
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !self.isUserInteractionEnabled {
            return
        }
        
        if keyPath == RefreshConst.keyPathContentSize {
            self.scrollViewContentSizeDidChange(change: change!)
        }
        if self.isHidden {
            return
        }
        
        if keyPath == RefreshConst.keyPathContentOffset {
            self.scrollViewContentOffsetDidChange(change: change!)
        } else if (keyPath == RefreshConst.keyPathPanState) {
            self.scrollViewPanStateDidChange(change: change!)
        }
    }
}
