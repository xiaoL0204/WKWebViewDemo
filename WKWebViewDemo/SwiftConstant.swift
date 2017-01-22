//
//  SwiftConstant.swift
//  WKWebViewDemo
//
//  Created by xiaoL on 17/1/22.
//  Copyright © 2017年 xiaolin. All rights reserved.
//

import UIKit

let S_SCREEN_WIDTH = UIScreen.main.bounds.size.width
let S_SCREEN_HEIGHT = UIScreen.main.bounds.size.height


func s_RGBA(_ red: CGFloat,_ green: CGFloat,_ blue: CGFloat,_ alpha: CGFloat) -> UIColor {
    return UIColor(red: red/255.0,green: green/255.0,blue: blue/255.0,alpha: alpha)
}


//let jsGetLikeSpanString = "function oc_getSpanLikeEle() {var spans = document.getElementsByTagName('span');alert('0000 '+ spans.length);alert('temp  '+ spans[0].className);;var spanLike=null;for (var i=0;i<spans.length;i++) {var temp = spans[i];if (temp.className=='cr like like-act' || temp.className=='cr like') {spanLike = temp;alert('bbbb'+ spanLike);return spanLike;}}}"


let jsGetHotelLikeSpanString = "function oc_getSpanLikeEle() {var spans = document.getElementsByTagName('span');var spanLike=null;for (var i=0;i<spans.length;i++) {var temp = spans[i];if (temp.className=='cr like like-act' || temp.className=='cr like') {spanLike = temp;return spanLike;}}}"


let jsChangeHotelLikeSpanMethod = "\(jsGetHotelLikeSpanString) function oc_changeLikeSpan(isLike) {var target = oc_getSpanLikeEle();if (isLike == 0 && $(target).hasClass('like-act')) {$(target).removeClass('like-act');}else if (isLike == 1 && $(target).hasClass('like')){$(target).removeClass('like-act');$(target).addClass('like-act');}}"




extension UIView{
    public var s_x:CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    public var s_y:CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    public var s_width:CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    public var s_height:CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    public var s_centerX:CGFloat{
        get{
            return self.center.x
        }
        set{
            var center:CGPoint = self.center
            center.x = newValue
            self.center = center
        }
    }
    public var s_centerY:CGFloat{
        get{
            return self.center.y
        }
        set{
            var center:CGPoint = self.center
            center.y = newValue
            self.center = center
        }
    }
    
}
