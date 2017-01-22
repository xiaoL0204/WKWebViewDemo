//
//  WebPhotoImgInfo.swift
//  WKWebViewDemo
//
//  Created by xiaoL on 17/1/22.
//  Copyright © 2017年 xiaolin. All rights reserved.
//

import UIKit

class WebPhotoImgInfo: NSObject,XLPhotoBrowserAdapterDelegate {
    public var imgUrl : NSString = ""
    
    func fetchImageUrl() -> String! {
        return self.imgUrl as String!
    }
    func fetchImgDescrition() -> String! {
        return nil
    }
    
}
