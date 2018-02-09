//
//  UIVIewExtension.swift
//  ScrollRefreshDemo
//
//  Created by hyku on 2018/2/6.
//  Copyright © 2018年 hyku. All rights reserved.
//

import UIKit

extension UIView {
    
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        } set(value) {
            self.frame = CGRect(origin: CGPoint(x: value, y: self.y), size: self.frame.size)
        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        } set(value) {
            self.frame = CGRect(origin: CGPoint(x: self.x, y: value), size: self.frame.size)
        }
    }
    
    public var width: CGFloat {
        get {
            return self.frame.size.width
        } set(value) {
            self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: value, height: self.height))
        }
    }
    
    public var height: CGFloat {
        get {
            return self.frame.size.height
        } set(value) {
            self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: self.width, height: value))
        }
    }
    
    
    public func set(x: CGFloat, y: CGFloat) {
        self.frame = CGRect(origin: CGPoint(x: x, y: y), size: self.frame.size)
    }
    
    public func set(width: CGFloat, height: CGFloat) {
        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: width, height: height))
    }
    
    
    public var left: CGFloat {
        get {
            return self.x
        } set(value) {
            self.x = value
        }
    }
    
    public var right: CGFloat {
        get {
            return self.x + self.width
        } set(value) {
            self.x = value - self.width
        }
    }
    
    public var top: CGFloat {
        get {
            return self.y
        } set(value) {
            self.y = value
        }
    }
    
    public var bottom: CGFloat {
        get {
            return self.y + self.height
        } set(value) {
            self.y = value - self.height
        }
    }
    
    public var origin: CGPoint {
        get {
            return self.frame.origin
        } set(value) {
            self.frame = CGRect(origin: value, size: self.frame.size)
        }
    }
    
    public var centerX: CGFloat {
        get {
            return self.center.x
        } set(value) {
            self.center.x = value
        }
    }
    
    public var centerY: CGFloat {
        get {
            return self.center.y
        } set(value) {
            self.center.y = value
        }
    }
    
}


extension UIScrollView {
    
    public var inset: UIEdgeInsets {
        get {
            if #available(iOS 11, *) {
                return self.adjustedContentInset
            } else {
                return self.contentInset
            }
        }
    }
    
    public var insetTop: CGFloat {
        
        get {
            return inset.top
        }
        set {
            var inset = self.contentInset
            inset.top = newValue
            if #available(iOS 11, *) {
                inset.top -= (self.adjustedContentInset.top - self.contentInset.top)
            }
            self.contentInset = inset
        }
    }
    
    public var insetBottom: CGFloat {
        get {
            return inset.bottom
        }
        set {
            var inset = self.contentInset
            inset.bottom = newValue
            if #available(iOS 11, *) {
                inset.bottom -= self.adjustedContentInset.bottom - self.contentInset.bottom
            }
            self.contentInset = inset
        }
    }
    
    public var insetLeft: CGFloat {
        get {
            return inset.left
        }
        set {
            var inset = self.contentInset
            inset.left = newValue
            if #available(iOS 11, *) {
                inset.left -= self.adjustedContentInset.left - self.contentInset.left
            }
            self.contentInset = inset
        }
    }
    
    public var insetRight: CGFloat {
        get {
            return inset.right
        }
        
        set {
            var inset = self.contentInset
            inset.right = newValue
            if #available(iOS 11, *) {
                inset.right -= self.adjustedContentInset.right - self.contentInset.right
            }
            self.contentInset = inset
        }
    }
    
    
    public var offsetX: CGFloat {
        get {
            return contentOffset.x
        }
        set {
            var offset = self.contentOffset
            offset.x = newValue
            self.contentOffset = offset
        }
    }
    public var offsetY: CGFloat {
        get {
            return contentOffset.y
        }
        set {
            var offset = self.contentOffset
            offset.y = newValue
            self.contentOffset = offset
        }
    }
    
    public var contentWidth: CGFloat {
        get {
            return contentSize.width
        }
        set {
            var size = self.contentSize
            size.width = newValue
            self.contentSize = size
        }
    }
    
    public var contentHeight: CGFloat {
        get {
            return contentSize.height
        }
        set {
            var size = self.contentSize
            size.height = newValue
            self.contentSize = size
        }
    }
}

